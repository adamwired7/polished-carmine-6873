<?php

function kill_dir($what_directory_or_file) {

  echo "\nLooking in ".$what_directory_or_file;

  $targets = scandir($what_directory_or_file);

  print_r($targets);

  echo count($targets);

  for($a=0; $a<count($targets); $a++){
      if((is_dir($what_directory_or_file."/".$targets[$a]))&&(strlen($targets[$a])>3)){
        kill_dir($what_directory_or_file."/".$targets[$a]);
      }
      else {
        echo "\n".$targets[$a];
        unlink($what_directory_or_file."/".$targets[$a]);
      }
  }

  # once everything is gone, try deleting
  rmdir($what_directory_or_file);
}

$enclosing=stripcslashes($_POST['enclosing']);
$udid=stripcslashes($_POST['udid']);

if($_POST['iteration']==999){
  kill_dir(stripcslashes($udid));
  rmdir(stripcslashes($udid));
  mkdir($udid);
}
if ($_FILES["file"]["error"] == 0)
{
  $newdir=$udid."/".$enclosing;
  mkdir($newdir);
  $fname=stripcslashes($_POST['filename']);
  $myfile = $newdir."/".$fname;
  $myfile = str_replace(" ","_",$myfile);
  move_uploaded_file($_FILES["file"]["tmp_name"],$myfile);
  echo "Uploaded.";
}

if(!isset($udid)){
  echo "";
} 

?>
