<?php
include "db.php";
header("Content-Type: application/json");

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET': // Listar
        $res = $conn->query("SELECT * FROM categorias");
        echo json_encode($res->fetch_all(MYSQLI_ASSOC));
        break;

    case 'POST': // Crear
        $data = json_decode(file_get_contents("php://input"), true);
        $nombre = $data['nombre'];
        $conn->query("INSERT INTO categorias (nombre) VALUES ('$nombre')");
        echo json_encode(["mensaje"=>"Categoría creada"]);
        break;

    case 'PUT': // Editar
        $data = json_decode(file_get_contents("php://input"), true);
        $id = $data['id'];
        $nombre = $data['nombre'];
        $conn->query("UPDATE categorias SET nombre='$nombre' WHERE id=$id");
        echo json_encode(["mensaje"=>"Categoría actualizada"]);
        break;

    case 'DELETE': // Eliminar
        $id = $_GET['id'];
        $conn->query("DELETE FROM categorias WHERE id=$id");
        echo json_encode(["mensaje"=>"Categoría eliminada"]);
        break;
}
?>
