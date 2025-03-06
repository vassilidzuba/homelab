#!/bin/bash

curdir=`pwd`

echo $curdir

rm -rf html
mkdir html

for f in  javadoc/*.jar
do
   echo $f
   fname=`echo $f | sed -e 's/javadoc\///' -e 's/.jar//' `

   cd html
   mkdir $fname
   cd $fname
   jar xf ../../$f

   cd $curdir
done

pwd

cat > html/index.html << EOF
<html>
<head>
<title>Javadocs</title>
</head>
<body>
<ul>
EOF

for f in javadoc/*.jar
do
   fname=`echo $f | sed -e 's/javadoc\///' -e 's/.jar//' `
   echo "" >> html/index.html
   echo "<li><a href='$fname/index.html'>$fname</a></li>" >> html/index.html
done

cat >> html/index.html << EOF
</ul>
</body>
</html>
EOF

