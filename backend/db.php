<?php
$host = "localhost";
$user = "root";   // cambia según tu entorno
$pass = "";
$db   = "tienda";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}
?>
