<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 
if ($handle = opendir('/')) {
    echo "Directory handle: $handle\n";
    echo "Files:\n";

    /* This is the correct way to loop over the directory. */
    while (false !== ($file = readdir($handle))) {
        echo "$file\n";
    }

    /* This is the WRONG way to loop over the directory. */
    while ($file = readdir($handle)) {
        echo "$file\n";
    }

    closedir($handle);
}
?>
