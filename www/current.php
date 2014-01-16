<?php 

// $lastval = $_GET['lastval'];

header('Content-Type: text/xml');
echo('<?xml version="1.0" encoding="UTF-8" ?>');

$udid=$_GET['udid'];

echo '<results>';

        // $dir = "/var/www/mobile/runs/".$udid;
        $dir = "/Users/newuser/repos/r1-effects-sdk-ios/test/www/runs/".$udid;
        $runs = scandir($dir);
	      sort($runs);
        for($a=0; $a<count($runs); $a++){
                if(file_exists("$dir/$runs[$a]/meta.xml")){
                  if(($runs[$a]!="index.php")&&($runs[$a]!="iphone.js")&&($runs[$a]!="iphone.css")&&(strlen($runs[$a])>3)){
                    echo "<test reference='".$runs[$a]."'></test>";
                  }
                }
        }


echo '</results>';

?>
