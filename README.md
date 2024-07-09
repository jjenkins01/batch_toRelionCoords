[![DOI](https://img.shields.io/badge/DOI-10.1038%2Fs41586--024--07680--x-blue)](https://doi.org/10.1038/s41586-024-07680-x)
![Bash Script](https://img.shields.io/badge/script-bash-1f425f)

batch_toRelionCoords is a bash script for automating the PEET command "toRelionCoords".

Step 1: Run createAlignedModel.

For example:

```createAlignedModel peet_prm_file.prm```

Step 2: Copy the files generated from createAlignedModel into motive list and model directories.

Step 3: Open the bash script in a text editor and input your tomogram dimensions and the output star file name.

For example: 

```vi batch_toRelionCoords.sh```

Step 4: Run this script!

For example: 

```./script_name.sh```

Note that you may need to change permisions before excecuting the script.

```chmod +x script_name.sh```
