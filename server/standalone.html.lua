<html>
	<head>
		<title>Symmath Worksheet - <?=worksheetFilename?></title>
		<script type="text/javascript" src="/server/jquery-3.6.0.min.js"></script>
		<script type="text/javascript" src="/server/showdown-1.9.1.min.js"></script>
		<script type="text/javascript" src="/server/tryToFindMathJax.js"></script>
		<script type="text/javascript" src="/server/standalone-bridge-ajax.js"></script>
		<script type="text/javascript" src="/server/standalone.js"></script>
		<link rel="stylesheet" href="/server/standalone.css"/>
		<script>
worksheetFilename = "<?=worksheetFilename?>";
symmathDir = '.';	//standalone.lua includes SYMMATH_PATH in its search path

//TODO would be nice to find mathjax async, and rebuild all mathjax cell outputs once mathjax is loaded
$(document).ready(function() {
	tryToFindMathJax({
		done : function() {
			init({
				root : document.body,
				worksheets : [
<?
local sep = ''
local dir = symmathPath..'/tests/'
for i,f in ipairs(require 'ext.os'.rlistdir(dir)) do
	if f:sub(-8) == '.symmath' then
		?><?=sep?><?=require 'ext.tolua'(f:sub(#dir+2))?>
<?		sep = ','
	end
end
?>
				]
			});
		},
		fail : fail
	});
});
		</script>
	</head>
	<body>
	</body>
</html>

