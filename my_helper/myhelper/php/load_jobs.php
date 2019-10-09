<?php
error_reporting(0);
include_once("dbconnect.php");
$jobowner = $_POST['email'];

$sql = "SELECT * FROM JOBS WHERE JOBOWNER = '$jobowner'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["jobs"] = array();
    while ($row = $result ->fetch_assoc()){
        $joblist = array();
        $joblist[jobid] = $row["JOBID"];
        $joblist[jobtitle] = $row["JOBTITLE"];
        $joblist[jobowner] = $row["JOBOWNER"];
        $joblist[jobprice] = $row["JOBPRICE"];
        $joblist[jobdesc] = $row["JOBDESC"];
        $joblist[jobtime] = $row["JOBTIME"];
        array_push($response["jobs"], $joblist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>