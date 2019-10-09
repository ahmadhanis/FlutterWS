<?php
$servername = "localhost";
$username 	= "slumber6_myhelperadmin";
$password 	= "S0Uyshkan^3g";
$dbname 	= "slumber6_myhelper";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>