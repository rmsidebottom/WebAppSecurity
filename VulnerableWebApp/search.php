<?php
require_once 'dbconfig.php';

$conn = mysqli_connect($host, $user, $pass, $db);
// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . mysqli_connect_error());
}

// generate id used as db primary key
$name = $_POST["search"];
$query = "SELECT * FROM $table WHERE name='$name'";
echo $query;
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
	echo "<table><tr><th>ID</th><th>Name</th><th>Message</th></tr>";
	// output data of each row
	while($row = mysqli_fetch_assoc($result)) {
		echo "<tr><td>".$row["id"]."</td><td>".$row["name"]."</td><td> ".$row["message"]."</td></tr>";
	}
} else {
	echo "0 results";
}
mysqli_close($conn);
?>
