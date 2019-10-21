<?php
error_reporting(0);
include_once("dbconnect.php");
//$jobowner = $_POST['email'];

$sql = "SELECT * FROM JOBS ORDER BY JOBID DESC";

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
        $joblist[jobtime] = date_format(date_create($row["JOBTIME"]), 'd/m/Y h:i:s');
        $joblist[jobimage] = $row["JOBIMAGE"];
        array_push($response["jobs"], $joblist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>