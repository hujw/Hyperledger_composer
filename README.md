# Hyperledger_composer
We use the "install-hlfv1.sh" to build the Hyperledger Composer environment. In our Linux system, we do not set up the X window. Therefore, we comment the part of the original file, as below.
```
#case "$(uname)" in
#"Darwin") open http://localhost:8080
#          ;;
#"Linux")  if [ -n "$BROWSER" ] ; then
#	       	        $BROWSER http://localhost:8080
#	        elif    which xdg-open > /dev/null ; then
#	                xdg-open http://localhost:8080
#          elif  	which gnome-open > /dev/null ; then
#	                gnome-open http://localhost:8080
#          #elif other types blah blah
#	        else
#    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
#	        fi
#          ;;
#*)        echo "Playground not launched - this OS is currently not supported "
#          ;;
#esac
```
