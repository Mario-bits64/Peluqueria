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

select totalProductosPedido(32);

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

select contarPedidosCliente(56);

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

call verResumenCliente(116);

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

call verTotalProductosPedido(101);

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

call cambiarTelefonoCliente(106, 654635372);

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

-- VISTAS

-- 1. Resumen pedidos
create view vista_resumen_pedidos as
select p.idPEDIDO, concat_ws(' ', c.nombre, c.apellidos) as cliente, c.telefono,
    p.fecha as fecha_pedido, t.metodoPago, t.precioTotal, count(*) as total_servicios
from PEDIDO p inner join CLIENTE c
    on p.CLIENTE_idCLIENTE = c.idCLIENTE inner join TICKET t
    on p.idPEDIDO = t.PEDIDO_idPEDIDO inner join LINEA_SERVICIO ls
    on p.idPEDIDO = ls.PEDIDO_idPEDIDO
group by p.idPEDIDO;


-- 2. Rendimiento empleados
create view vista_rendimiento_empleado as
select e.idEMPLEADO, concat_ws(' ', e.nombre, e.apellido) as empleado, e.turno,
    count(*) as servicios_realizados, sum(ls.precioUnitarioAplicado) as ingresos_generados
from EMPLEADO e
inner join LINEA_SERVICIO ls
    on e.idEMPLEADO = ls.EMPLEADO_idEMPLEADO
group by 
    e.idEMPLEADO, e.nombre, e.apellido, e.turno;