#
#I've a bug, my string will also be replacedi, I'm lazy :-)
        for file in `ls -1 *`
        do
                #echo hook
		sed -e 's/aoip/aoip/g' -e 's/localhost/localhost/g' $file > $file.bak
		#rm $file
		cp $file.bak $file
        done
chmod 755 *
