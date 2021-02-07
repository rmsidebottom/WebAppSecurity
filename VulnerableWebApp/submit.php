<?php
require_once 'dbconfig.php';

$name = $_POST["signee"];
$msg = $_POST["note"];

$conn = mysqli_connect($host, $user, $pass, $db);
// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . mysqli_connect_error());
}

// generate id used as db primary key
$id = substr(sha1($name), 0, 6);
$query = "insert into $table (id, name, message) values ('$id', '$name', '$msg') on duplicate key UPDATE id=$id";
$result = $conn->query($query);

if (mysqli_query($conn, $query)) {
	echo "New record created successfully";
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
mysqli_close($conn);
?>
