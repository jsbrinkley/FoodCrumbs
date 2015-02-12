<?php

require("GeoTools/LatLngCollection.php");
require("GeoTools/RouteBoxer.php");
//this script will take a json string of a valid google directions response and will
//return an array of boxes. This function does not do the checking itself

//argv[1] = ruby array
//argv[2] = radius of line between points
//we could just write
//if( $argv[2] == NULL)
//and asign a default value but we should handle that in the helper

$points = json_decode($argv[1]);
if(count($points) === 1){

array_push($points,$points[0]);

}

$collection = new GeoTools\LatLngCollection($points);
$boxer = new GeoTools\RouteBoxer();
$distance = $argv[2];


$boxes = $boxer->box($collection, $distance);
//boxes now contain an array of LatLngBounds
print_r(json_encode($boxer->tojson()));

?>
