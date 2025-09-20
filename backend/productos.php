<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");




include "db.php";
header("Content-Type: application/json");

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        $res = $conn->query("SELECT p.*, c.nombre as categoria 
                             FROM productos p 
                             LEFT JOIN categorias c ON p.categoria_id = c.id");
        echo json_encode($res->fetch_all(MYSQLI_ASSOC));
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $nombre = $data['nombre'];
        $descripcion = $data['descripcion'];
        $precio = $data['precio'];
        $categoria_id = $data['categoria_id'];
        $conn->query("INSERT INTO productos (nombre,descripcion,precio,categoria_id)
                      VALUES ('$nombre','$descripcion',$precio,$categoria_id)");
        echo json_encode(["mensaje"=>"Producto creado"]);
        break;

    case 'PUT':
    // Leer JSON enviado
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data['id'];
    $nombre = $data['nombre'];
    $descripcion = $data['descripcion'];
    $precio = $data['precio'];
    $categoria_id = $data['categoria_id'];

    // Validar que ID sea numérico
    if (!is_numeric($id)) {
        http_response_code(400);
        echo json_encode(["mensaje"=>"ID inválido"]);
        exit;
    }

    $stmt = $conn->prepare("UPDATE productos SET nombre=?, descripcion=?, precio=?, categoria_id=? WHERE id=?");
    $stmt->bind_param("ssdii", $nombre, $descripcion, $precio, $categoria_id, $id);
    $stmt->execute();
    echo json_encode(["mensaje"=>"Producto actualizado"]);
    break;

    case 'DELETE':
        $id = $_GET['id'];
        $conn->query("DELETE FROM productos WHERE id=$id");
        echo json_encode(["mensaje"=>"Producto eliminado"]);
        break;
}
?>
