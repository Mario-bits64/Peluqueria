-- 1. Facturación total por cliente

select CONCAT_WS(' ', c.nombre, c.apellidos), c.email, SUM(t.precioTotal), COUNT(*) as totalPedidos
from CLIENTE c inner join PEDIDO p 
	on c.idCLIENTE = p.CLIENTE_idCLIENTE inner join TICKET t 
	on p.idPEDIDO = t.PEDIDO_idPEDIDO  
group by CONCAT_WS(' ', c.nombre, c.apellidos), c.email;
order by totalPedidos asc;

-- 2. Servicios realizados por cada empleado

select CONCAT_WS(' ', e.nombre, e.apellido), e.turno, sum(ls.precioUnitarioAplicado) as ingresos_generados, 
	   count(*) as servicios_realizados
from EMPLEADO e inner join LINEA_SERVICIO ls 
	on e.idEMPLEADO = ls.EMPLEADO_idEMPLEADO
group by CONCAT_WS(' ', e.nombre, e.apellido), e.turno;

-- 3. Pedidos completos con cliente, empleado, servicio y ticket
select p.idPEDIDO, p.fecha, CONCAT_WS(' ', c.nombre, c.apellidos), s.nombre as servicio, 
	   ls.horaInicio , CONCAT_WS(' ', e.nombre, e.apellido), t.metodoPago , t.precioTotal 
from PEDIDO p inner join CLIENTE c 
	on p.CLIENTE_idCLIENTE = c.idCLIENTE inner join LINEA_SERVICIO ls 
	on p.idPEDIDO = ls.PEDIDO_idPEDIDO inner join SERVICIO s 
	on ls.SERVICIO_idSERVICIO = s.idSERVICIO inner join EMPLEADO e
	on ls.EMPLEADO_idEMPLEADO = e.idEMPLEADO inner join TICKET t 
	on p.idPEDIDO = t.PEDIDO_idPEDIDO;

-- 4. Mostrar clientes que ademas de servicios han comprado productos

select CONCAT_WS(' ', c.nombre, c.apellidos) as nombre_apellido, p.idPEDIDO 
from CLIENTE c inner join PEDIDO p 
	on c.idCLIENTE = p.CLIENTE_idCLIENTE inner join LINEA_PRODUCTO lp 
	on p.idPEDIDO = lp.PEDIDO_idPEDIDO
where p.idPEDIDO IN (
	select lp.PEDIDO_idPEDIDO 
	from LINEA_PRODUCTO lp2 
);

-- 5. Servicios mas rentables del negocio

select s.nombre as servicio, sum(ls.precioUnitarioAplicado) as ganancias
from SERVICIO s inner join LINEA_SERVICIO ls 
	on s.idSERVICIO = ls.SERVICIO_idSERVICIO
group by s.nombre;

-- 6. Resumen mensual
select YEAR(p.fecha) as anio, MONTH(p.fecha) as mes,COUNT(*) as totalPedidos, SUM(t.precioTotal) as totalFacturado,
       AVG(t.precioTotal) as ticketMedio, COUNT(distinct c.idCLIENTE) as clientesAtendidos
from PEDIDO p inner join TICKET t
    on p.idPEDIDO = t.PEDIDO_idPEDIDO inner join CLIENTE c
    on p.CLIENTE_idCLIENTE = c.idCLIENTE
group by YEAR(p.fecha), MONTH(p.fecha)
order by anio, mes;

-- VISTAS

-- 1. Resumen de pedidos 
create view vista_resumen_pedidos as
select p.idPEDIDO,
    CONCAT_WS(' ', c.nombre, c.apellidos) AS cliente,
    c.telefono,
    c.email,
    p.fecha AS fechaPedido,
    t.metodoPago,
    t.precioTotal,
    COUNT(ls.idLineaServicio) AS totalServicios
from PEDIDO p inner join CLIENTE c 
	on p.CLIENTE_idCLIENTE = c.idCLIENTE inner join TICKET t
    on p.idPEDIDO = t.PEDIDO_idPEDIDO inner join LINEA_SERVICIO ls
    on p.idPEDIDO = ls.PEDIDO_idPEDIDO
 group by p.idPEDIDO;

-- 2. Vista con el rendimiento de los empleados
create view vista_rendimiento_empleados as
select 
    e.idEMPLEADO,
    CONCAT_WS(' ', e.nombre, e.apellido) AS empleado,
    e.turno,
    e.jefe,
    COUNT(ls.idLineaServicio) AS totalServiciosRealizados,
    SUM(ls.precioUnitarioAplicado) AS totalGeneradoServicios
from EMPLEADO e inner join LINEA_SERVICIO ls
    on e.idEMPLEADO = ls.EMPLEADO_idEMPLEADO inner join SERVICIO s
    on ls.SERVICIO_idSERVICIO = s.idSERVICIO
group by e.idEMPLEADO;


-- FUNCTION 

-- 1. Total de productos de un pedido
DELIMITER //

create function totalProductosPedido(p_idPedido int)
returns decimal(10,2)
deterministic
begin
    declare v_total decimal(10,2);

    select ifnull(sum(cantidad * precioUnitarioAplicado), 0)
    into v_total
    from LINEA_PRODUCTO
    where PEDIDO_idPEDIDO = p_idPedido;

    return v_total;
end//

DELIMITER ;

-- 2. Contar pedidos de un cliente
DELIMITER //

create function contarPedidosCliente(p_idCliente int)
returns int
deterministic
begin
    declare v_total int;

    select count(*)
    into v_total
    from PEDIDO
    where CLIENTE_idCLIENTE = p_idCliente;

    return v_total;
end//

DELIMITER ;

-- PROCEDURES

-- 1. Ver resumen cliente
DELIMITER //

create procedure verResumenCliente(in p_idCliente int)
begin
    declare v_existe int default 0;

    select count(*)
    into v_existe
    from CLIENTE
    where idCLIENTE = p_idCliente;

    if v_existe = 0 then
        signal sqlstate '45000'
        set message_text = 'El cliente no existe';
    else
        select 
            concat_ws(' ', nombre, apellidos) as cliente,
            telefono,
            email,
            contarPedidosCliente(idCLIENTE) as totalPedidos
        from CLIENTE
        where idCLIENTE = p_idCliente;
    end if;
end//

DELIMITER ;

-- 2. Ver total de productos de un pedido
DELIMITER //

create procedure verTotalProductosPedido(in p_idPedido int)
begin
    declare v_existe int default 0;

    select count(*)
    into v_existe
    from PEDIDO
    where idPEDIDO = p_idPedido;

    if v_existe = 0 then
        signal sqlstate '45000'
        set message_text = 'El pedido no existe';
    else
        select 
            p_idPedido as pedido,
            totalProductosPedido(p_idPedido) as totalProductos;
    end if;
end//

DELIMITER ;

-- 3. Modificar telefono de cliente
DELIMITER //

create procedure cambiarTelefonoCliente(in p_idCliente int, in p_telefonoNuevo int)
begin
    declare v_existe int default 0;

    select count(*)
    into v_existe
    from CLIENTE
    where idCLIENTE = p_idCliente;

    if v_existe = 0 then
        signal sqlstate '45000'
        set message_text = 'El cliente no existe';
    else
        update CLIENTE
        set telefono = p_telefonoNuevo
        where idCLIENTE = p_idCliente;
    end if;
end//

DELIMITER ;

-- TRIGGERS

-- 1. Comprobar stock antes de vender
DELIMITER //

create trigger comprobarStockProducto
before insert on LINEA_PRODUCTO
for each row
begin
    declare v_stock int;

    if new.cantidad <= 0 then
        signal sqlstate '45000'
        set message_text = 'La cantidad debe ser mayor que 0';
    end if;

    select stock
    into v_stock
    from PRODUCTO
    where idPRODUCTO = new.PRODUCTO_idPRODUCTO;

    if new.cantidad > v_stock then
        signal sqlstate '45000'
        set message_text = 'No hay stock suficiente';
    end if;
end//

DELIMITER ;

-- 2. Descontar stock tras vender
DELIMITER //

create trigger descontarStockProducto
after insert on LINEA_PRODUCTO
for each row
begin
    update PRODUCTO
    set stock = stock - new.cantidad
    where idPRODUCTO = new.PRODUCTO_idPRODUCTO;
end//

DELIMITER ;