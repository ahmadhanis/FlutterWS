<?php
//error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$jobtitle = $_POST['jobtitle'];
$jobdesc = $_POST['jobdesc'];
$jobprice = $_POST['jobprice'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO JOBS(JOBTITLE,JOBOWNER,JOBDESC,JOBPRICE,JOBIMAGE) VALUES ('$jobtitle','$email','$jobdesc','$jobprice','$imagename')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../images/'.$imagename.'.jpg';
    file_put_contents($path, $decoded_string);
    echo "success";
} else {
    echo "failed";
}
?>