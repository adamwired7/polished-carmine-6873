<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="iphone.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		var udid = "<?php echo $_GET["udid"]; ?>";
	</script>
	<script type="text/javascript" src="js/jquery-2.0.3.js"></script>
        <script type="text/javascript" src="iphone.js"></script>
</head>
<body onload="loadTests(true);">
	<div id="testhold" class="testhold"></div>
	<div class="history" id="history">
	        <div class="temphistory" id="temphistory"></div>
		<div class="historytitle">History</div>
	        <div class="play" onmousedown="repeat(-1);">|></div>
	        <div class="stop" onmousedown="cancelRepeat();">II</div>
		<div class="allhistory" id="allhistory"></div>
	</div>
</body>
</html>

