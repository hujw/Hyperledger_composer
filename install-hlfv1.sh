ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.0
docker tag hyperledger/composer-playground:0.9.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �UVY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(��1�cq8�2����k�m;��ǒ:�}5ޤ��S�@�V},s�eC����^�( �>a��o�Kw$U�֑.���K"Ֆ�@a͞	-*hE��.EPM�rl7K B`y�Ya���$��2�ԝ>R��+*b�(U�od3k�;/�w� ��R[sR��C�A�*ZF]� ��V�j�*�/�)�aT�����1(�ĕ�{<ٲ���Fܼ� �A��fF�9�˹ÎF��ޮ�U�"X��т~�G�ͺB(!� �f����vPJ$f#���@�
�f(�TIѶ4�E�2�H�K�gR��`���`x�Iz1�v��)�"��z�#X-�̦1N�j��JqC��4�%�M�1�4�tl$�@���b�	�T�<mC��)o*���T�aVG{	�v�$M�Gt�6����-*��*i3�Tq'(-��K�Pݩ���������W�E]~����	~���d��-]��C��w��R�=X�p"��N���F���	����?�'�x���|��1���c�߁��]ݝ��v�4H��W�?�q���(��8&��?��o���HM�#5�nR�Ѷd�'O���?�j�}�K
�ͣJa���0o/h��_̮��"G�!�iu�� ��1�e7��?]��<`!�7��S�O�r>|l��� ��ؕ����D��<�!�b1v!�� ���W������h�H�Q�0���ö���f� �f0�����@�b� u�B����}��i;�l[x��1`ZjGr0��Ն$Hj;M�2��ؚ*C�&%Pgn��F��Z�)��p:��ܔ�b�]c�Ck�"�xI��+�	u���Հ��_Y��5�ɡℙ���M)�_����canq��P�������i���kmUSB�%7�a�n�5�B��c���]#8 	�e^���c��1	�hx��+j��n���*7
���:�OÅ%��������5�?A��dw�*���c��70��f����?�1�Z��ubNSr���id��`��@���uUo\n
ؔ��v��3�E��'O҅�i���3J��7X�,�H��j�4x�g���M�[��[BdG�� |�}"��F���aK�K��Ir��*"���Թ+��q!��!k� ��������`��]H6�B��_c.
���%�6��o�n2�n��V1���6�T���}����z�8Fb3nf��$�M��^�,���^d�Z�TJ��=tn� f0��c��V��K�eEٕڪCa�}��&�(�*V��tQ���5(;��T�&0�v�4�~��OI_Rِ�j��W�4&F?���z:Pu�l^o~�O/�&����v�aψH��fA����K�!�>�[5/G�<S/ڒL)����c�܉����av�O�O,�s�����1�ٖwDc���x�gH�م�w>��H�K󋫙�&b�AZ�6��aU�24���nƒj��ֶ,�5��cX=*�-��`8�����Q%U���ߣ�	z��{O�+{+��'��˘%�(�Α��!$���ѮX�d��g�*���  �m݆�����&�z� �3��{:�lxu�(G�X~2���+�Q~+U�\=�fsba�z5�h�xgy�Ԇ����HR���[�Zp}�go�����O�Wb�+��x2�������o��!�啬��<R�%��[5h�໯��D%,N��dBA�+t ��V��P���#��Y�"�p�@(�`/�?�Il��/�U���8�3�6�����$��|`��}�0v�'Y�]. '��e���Dl��=�{���T�{��-��A4�B������(c�Aof_�:��1�?�/ݞ����	&_��&�?^�0��-�����k����a��E�����o�<���������g.0��+�U���5�e; Z�a� ��ꎷ!�jI�b�)��������@(�J��]=���$�M��g;����K8�Bu�*��|���1F4gI����#U�OZ��nt��AIGQ�.,�������:�g������@�e�@Ȫ��G��1�˳j!/+;�K�E���� Bi�����n����[��<�C����1���<ɕXM"�c��!�u.�3�ĩ��^=����س��Q<b�l��¤�Nt=���͗?���ͷ�'�����s��B���U���@p�T�>�0���Y�91�Rf�1���a�a�?˳�B���{��a:ms�̇�!V?H�^�o�-8��#:���!�� o�wg�y��s{ ����e�}.��	�-@Ȝ�J����@,l��fe�����#5�K\�GcZ�<�MլxW��͡��5�	�>Bn��?�C.��l׮���q���y�n��/�W?�M���I�SU�cQ�?����#YIQ�Ӿ�ypn��Q��5%� Խ�V�w�2�W���#�׸k���3�nOKc��������'����<������s���.�;�B`�Td�Zv/�+�50�`̭^8iN�%�r���:J	G�'�䶘^��<�:&s=[xd�C��Z��d��p8��D��<��H��QQ�GB:]+a�ZH�U1U%��vs�$�b!����u���dE����Q�F�I��L6�9�w������ɌΦ�Q����G"��"fl=Т�Q�bWg�ޮL�_S;�lu��@(��Qi���h�HCX�gY����f�R>n��*��T��o����w@�	B2X�5M���� �P�{.�r���-��3����޷��!�b���[�D�,><�3�b�o.�������Z�Ȯ �S�m^�δo�r	) "������ujg�V�0�mb��+���W��b����K|����uxe��͒ŮO�~ר���?{+/�i�?���h�=��/�?�Ӷ�m.��d�A?��?� �����������C�+�G'��v��q	O'�2�H=��Fd��&���F/���F����� !x��ʻ��X��.��{�i���\
8Y��������/s�w�?�9�
�w�q��AG��J�n�F�zg�d���7�g��R����V�os)�$���r<�?�����ArKUKm4P��z�ˣ��	Gp>�i��6��'��	��O>��p.��뿹�m���\�0���5��cP�a�\�?y+��*�Ax�x�G��A�gG�žs�w�8���'���Gf�>���})\�S���+�.�s+�ϫ�6\���E��a����wD�>�2�5�O2�=�!���{!�2]�/1�ޭ�굚��<ī��k�	�Pt��z��w��1���D4����fnw������e�?�a���4MCc���f����Ź��7x�Mw�^�)JUP�?CіA��ی/h���Ur/~�Q,�Q���e*�g8�^{G�j�ƲD�rze��x��!Tj5.&գP���xi���e9㘨R��VW9r�zl��u�.�X���������&c�O�-C�Q�LC�b&�)�\�ndSBU$��z.�Mm�R��i�lRhdK��R|����*����V��3�sa+�h�6O��R)-'����=�S���n����vw��j��1��m��[�;��-�ܯ�{�d��%�r�n��z���,����Ń\RvS7s�Z������l8r�L�n�;��%�p�����F�9˟L�8{�;z�ꁄ�zn����6�3T�s�U���M
�UAۭ�ʹ��,+v���ޙy�Z��ZZ3W��n$nS����X�P/믚�Vޔ�|'W^�n�����A� Ú��$��l����c���N{�[ur']���y�o��c&%����wZ(��RC��|��q�̟�-S�v_W6��:1����L?�}�:�7wc)�Jn�;��jW��ۉx|�������;;f��P9O��|\Οl�:q)��2B7�@����.�6#I�oc��K�p=+�J�\N02���J;��9�K�Į��tK�� t����C�s�L��YCh*���٧�,�ĵ��k��r��|�"VAmW�H��N*�etS�ԇ:*���b���e!ۨ��[Ɩ���/e]Q_'�j"���6�D夾��W�U��f2L*�櫇�N�T4�H�U�є-�|��x�c#)=^�N�t砓9g�ΡN�@̧ǈ}qqq�����#��O������˯-0�]o�/úw��� �T&� l�'~�?�[��\�7)��n���v��]���O�O���h<>��GYn���| ���]4�-q��>�r�̦���${��J.��~#����ӕ��\*5*���=XMJ����;~DYFc���]9V$f_��^�.�����e!��R!ƾ��J"g:��A$�T��)ET=}�yD�"�+g�׍l�O����N�?�;ˬ�"�^�\ѕ~;�}ёXjK��k4���Z�p�Ø�c��?�����6��k�]�<�0�n���������Nr;�
N��A��GT� 3�9������9��Z�������g���)iL��������O��W�R悔�~���~�w��H��7?eW��+u��ec�U���)
�%�xT���z���Q�.�5�.3�8#����W�++K��l�_��������7���O����_l��/���̋�_=���!uIt�����`�6۫�����O�����x?X��K��R�n���[K��D}Q!���_��'K��`�g�}2�� �K�Gd'�^�b�?�t�����!���:HN��d�����qe�/��y�x9L��R����������?���>��o����o�꟟�����x?Er�|ޠ�g��\0A��lt����.��xO;��en��l�R|"z�)�=#}�A�����ѣ���4)�{ѬG�#G�f�u�1	+byW,㯼����.�Ii����g���0M���
	ca$�69�^Xu�1���(�����fx{��'!})�|��IR�O�rP�0����,�:�$�$q�(���)�z���b�(qq��>����F�7� ������uFj~�t�>u쉅�GIW�� j����ٻ�����'���x�`W�3I�f���@#�M�DQQ�rh��H-E�(�4�8H.F#��N�b'H�}3$@;� � �!�O)��T%��]ݥ�^����������G�h���mV���}��@?<'oɋ�V�h�bx��-�W���Y��lUbX)�8���YN6,{5��>q.f+�
[Y��x��>=���;�W.���̣Ez���by�Z��x
�#?���#�X�~����Nl�N4Y��`�yT]�P��+��4ύ'�Cp5ʋD����Ǧ;zx�c���qG���D_���d���ɪ]���J?���M���)��#v���*X���BX_ǹ����r��C��ko�(��}�qp�}WW�����e7F�c$Y�۟x���{�2�����5~a�$=��.MZ.y֍~/�9� dq�.��
]e.�s��g��¬��JW+�"W#���5�<;���c�`Β\��Y��$駶���Q�A.�ƋNr��ղ��`zY�Ɠ�v�x�'�?��	~$��N�b�ƕ$��4�~����NZ��������f�4�BUV�C��*�����?:6{�:���C���se�T��o�TH���GtR��P����:]`��MW�;��b.,Gdn�ga�\��5;�'���bf�����+�>ӋO�M�.�ړE����	��즓X��_Z���Ŵ���ǆ��Pn3b������fZ��6��2p�'w*v[P��ץ���Y��I������}�����jP^~�������q���n���������~%�w���+���_}�~��?���?�x���ߤS�V~T~Pf�o���K����W�X�kI��Bi��?�qT���CGM,��M�ng�v�me3(l�N������X�Y�2�&��S�֥?���~�����?��o������?|��/}��*�?+�RR�� x�4X�~�~���E���S�~�4��������?��ԏ�J��[���%��@�,34MZ�qj�D��P� Q�B���A��'ɛ����`�2 ��e�oG�UU��sRZ��:
ݭtt����Ҥ�`�y��/�
���\��~~�!���SN!�K_a�ܬ5g'�f��7��%c��@k<��:FEP���g�R���4�ϼ�g��gI��M��$��&���v&�uYr
	I��bh����t_UʦS�L^r"�_�'��L�4c�a��vxr�dl����3�Pr�fT+a-�yA��a[
��B2�H�e��ɜSC�l%�_��,�"�H��$@9Έr�<%��X[0IE�K)$��twyAGt)�v�mnς������ح�y�0�i��8���4��"s��N�H2T�tYrD�5ZCt ����Z�:��j#���%��h1T$�+�Ki����-~D
�J[z��";6�L��L���|D��&�ƲI}����ғU%��U����
b�$��R��hpj��.d�<�a�K�U<6ZȰ���#Ab#&Z墓�h5ԙ�Hs)�K6c���v�;T8�� �I�\��՞>�sz���>8�0��Q�B�ju��A7r����|Gf�Ja�J/�"��U��zyQ �D(hR$���T�(�����D�`�U�Hf��mb��*�@-�,F�&Pm�<��E{��w�Q�&!��:]$'\���i��$��	�Ҽ�t��2���p��&�K$��P2�Iwje�G�-�+�'�r����,����Y"��G;�	�u ������,��[Z���Y�tPչ�vD�ͬh
�JM�ކS�QY�Yt�<�(��mp����3����	)�5l�xN`5�A�E���چ��c>�{��F���ST��y:<�� ��s�� @h�|%Ö�B���2���:��*�Ԉ�rn��Ŗ5�*�+��aiҹLX���J}}�Rক<�My���� 7-�nZ�ܴ��ip��<�Mx����\�X�7�����^I~c��j+�=�t+��S�x�R��A��ߟ9���k����<>9>������k'�[�PO<�ӛ�_�&�;��|�tO�Go~���x��^���Rr����ƻ4?g�WQ�PR:�QNc�Sx��@;1ދ�1�7����^�x�`��&e|MiR x9/���� �Y��Ru�_ˎ˃�Fe(�|�&�b�(�<q#q4��	W��Ś�L�\_)�Jcƪʷa�S���k���l�� s�ar=�Pjy�B6�զv~j�4�o��xgI�B�~�Wd)������W��k����m�a�)�z����X�t�f�5�k�e��Y&�\���sQ�Y��a���%=�0��%�&��l�ȕ2n�ى��B�*v�鎪��S�X�<7�N�p���8e�i�����z��U;ʀX6#��=�����8R�y���h�����5%����`P�e��b�.�2�>8 %3D�44�YC�գ�Ǩ�М�l�����*��,53�C���a�QlG}Qa2~��h�����s�*�E�`�b5�Jo*�uS�e�J��j�g�Z��tu�$;��b�'U��S�Xd��=���e����q�A���,�v���ϧ�����':�������?O�~� �������?Xj��>H�̓�7�9��+!���|fp���TuG-��ғ��"BQ΄���=kŝgH�Xq�ȹ�(��,�.�OPxbX��:� O+��=��h+T<�%T,�71
��Z�X�w�:r����xKb�ё3#���N�KzMT�;���k����s�#��h$9]�:���)Ԧ����7�X-r�>:�nP}���d5� K�8�m-�.n��bw����o���?�(J�b�a�K���@��bܙ�Å�3l�<@{ݢ�!M�V�:��ZDؖ'�>u:��i=�c 72�%��c ��b�,ceg��ZH#�)�.D!h-1P�Pd��AS$An��1�����Q=(��2���A�:�hT�&Zѭ�e�dn��1���xɷ����~��K�%yoM����n�Y�I��	l��u 0�8V^R��?I������u ��T�NW���H��B:�Y�詜G#����.�E�1��Z~T��dLU;+���\E	���&���N�`�|�G,DD'����l�MV��x����F�D��M��%e6��t��@�JOke\OQ#�)w5����U��UW�̠Xw��S	K�h�����X9�G�!X�0Ocx�}�R���s��U��s��9��/�>�>Z�{�G�>cѪ���~�����_�����5V�Nk�
��ѐI c$�6!��5��q?���pf�8�ymDN�	B�j��
g0f���*1�Z�q���A���~8�J�cF��ka0ke���kXP�7,�m�%�1S����<�ق�y?��e�!�Tf�^GRaII��:<^]���b5c-� L�=p>�W{�
��e�;�	�X����X���5�nz�F�6D��v=��-ԥ�tv�P#�[NĽzKe�¨Җ¶^�5�%� B\y8��1jň����R5S�XP@G�`H�D�7/�+\�DO����t�R�p-��F������I���럄��@�}�ID�_XE4%+��E��0up�x�+��$G���P��ԛ�W��C�����J��FGv�V��k���|�=��O>��v��<ʲiw��S?�,�A��X�{��;突�y���s��k<�����j��/_��<\��s�e��E�;���7c=�q�s����O����ى?�����L{�^� �GcQ{���Ob��	;����4GVZa��R���۪��"�g>���A8 >��yQ�)����M\�O��;���}��۠��f�̖{<���� ���z��Q6�4����۠;���7��A���A��/k5w�=���nc���q���m�]����?�E��t[�A�����O{������F7�?���۠���]�o�!��������?�l��=����_��}|a��]�g�n�/��g����}��[�}��Q��p��(�z�>���%�����A;�������)�����������������]��1���������u1��g�����ѝ�����,����۠�ɫ+��������;����?�=�����ΰ�<g���7�|���]���X�S��\��
u�6ㆴ��}F������@AǾ}c�_�#'�����>>���A�:�'�QN��a
���KP�r�V�� :o�ZD�6���&�w�^_�I-3�G^ؑ�Q�K7�bd7�����Lw`[{�'��i��ǣ�:�q�;*8����������(�nY/(�邍���3���|�A:Q�NQ�D����
9��ÎXt�&pm�5��8i���K�4'g n6\���
҂�/뎲�����N�����e���w�c��k�±?�����h������]������]��0s6Y:L�(�������e�x�PH�m��1P��Q�ε!׳���ep�l�&�8|^��٦���(o������Z��kRQ�=��<���\!�:��v�)��Il@���ѫͥ��*t�? �b2��5�U? ���*s���!ݑ��"b�1h���X���0vR�9�s�lf� ���wfM�jY~�W��-��� ����L�t0�8�������{�^�5u%�D��"�L*#���^����(/M7� ��v�͢����ݹ>�{V�S�f���l0������{zS�?p����O��������?����K��g�Ɂ�k,�_������FhD�aU[�����~����{{`��a��a��7��"�N��������$:�8&c����$�r*r*�蘹���4��\�#����#h�8��W�
��W����3�غ�*M�-b�!=ns.����Ul��wm�[����w�S�Eܞ],�\�W&T/{��f@,�Ò���RH�bp�)����'�vb.��U�>�^��*���6_��U�����?�>�H��j����MU� �4q������?��������f�b�q������������?�|cES�����,��&��o����o��F{���/���L�1߸��}�8�?�j�/�7B���d���
�?Jp���+��ߍ���ď�o�S�W}�bk�4��4۔ŏλ��b�V���?���n�6��zTh��i�������\k�Z���&f�w�>������ W�v'��={YNuZV��er8���:>v�x��]�Rl1�¸^�������U��f�G�NW���]��:�W(������}S��wW.��69V�P�v��ɲ){6i[۶B�ԣ�D��FmS��!=��BS��_��k�1�J>�v��\�A �T�ЭN̬�q�fC�+Lx}�ˊ{�@�c�v��V������ތ�GC����=ǒ�B��ҵ��}�R���_�@\�A��W���C�� ������?���?����h����������?�������N�=_���,���`��U�G��m[�mNyy�a�J�=�SN�[Q�K�z�L�����CcAF��wV^sb?������U���M͟�a�&oy��]O����/��c��w`e�.��ߺ���ͭ�$��6y�{�)�7�B�>����<p�}�d.ʀR�X_
���f^��c���$/;����?���T4S��1��?���A���Wt4����8�X�A����������?/�?��4��?�O�㛢~��k���?��9���������O��	����7���Ԁ���#��y���	�?"�����/���o|�VQД������ ����������CP�A0 b������ga���?�D������?������?�lF���]�a����@�C#`���/�>����g9�I�y��j�o������Ɵ�ߘ�Yg6�Z�9�=��E���?���?7�sP���uRt�Y|����Qg��=Ic�'���9���L�WlG�/C"2F�����+�SS[ӣC���؜�vՒ.Z���:��r�l��e���_x���n�?{|U�༿����^.d��T:�)�lev�o􏇛w0��`u*�,%mڦp���޸���Yh��V���@�TfQ�Ju��E8�Y�.��O�k�j�B ;�B����p�a���EZ:v�{����N9k�1f��E�=��W����g�&@\���ku�2��� ����?��y����p����r!��<�������҂(r\������H�S"˦�(�,˱�D�C��z����78�?s7�O�σ�o�/����{w��/C?��ww���V����Go���kylx�r��a��q���k�.f����|�XO��raˣ�,�^�PXeXus{<��6�z�
q����rLȋe�/'�Н�r�M�E$h�Z�_&��If_І5��X�����=�)�8f�����t4���� �;px���C���@������������G�a�8����t�����`��@������Ā�������D���#�������������������������B�!�����������Y�~��|���#�C�����g񽳷L����|�������8?|3���o&�����x�Hκ5y�d�,������,��v�����kf����<��Q��ڛ��Yk�V_�K5�/�l#]��za�aݕ?|����4��9ao�x3*zt6m��}�Ǫ�̔�N��J��e���Ч�XwO!-����G|�td���0'�5�5�4r��J��t��u8=�?�eMg�q����C�<��c�ʲN�ۡ���-��۪pݒ���[��s|2Z7g>-M]����'��	���p����ux��e��9*]�����+�\����'�1e�6�P%�ߥP:V����ݒ>��j��2�_O����۹���0^��}梕3�mv4��O]%ծ�ږ��X�;��=��Nn�e �SA7�u��U.��r-%��$�N_妄k[��l��q��M��s�dI!F��z���)�Ͽ���n��� ���?��@���]������\�_"i:�*ɲ4�i6ʙ,⥘�D�ᓄgi�Is>�$��h>gE�f�$Ob*�3	�?~��?��+�?r������ق8��Ó8��"��0��?�#�%^?�Xc�T����vgmUI�I��[uƺ�N8/����T�>�}��Z��|(��,����v����A{{���)j������?�����������	p���W�?0��o������q����3��@�� ���/t4������(�����#���Bb���/Ā���#��i�������=���+�4 7GS�����M��r1�]6;���,��4`�����{��.�t���S���-q�8�NG��� ����k��Y͜��l�|�媥�e�L�j�V]�?O�۸c�u�u��t[�6��Q�ߎ׬������֦��҃�b��]���%������%	�����<��ԙ�'b������XS���cY2]�J�EκQJ���D��FY���{�ӝc���3�H���2aG�2Vμ�o���?��q��_�����?,�򿐁����G��U�C��o�o������1���E6����?�~`�$������=]�[��7��닾#�K݅�@!	�����q�&U	�l���f"�YA��Q�P�0�+kL/��sZ���VFӓ>`]k�O������<ߢK���/E�z[Y�i�����z�YAMe��ц��{ɫ#���_=YU4y���n�9vM����滍��F���@����t���j;>����y�/S��Ү#�^�����V,�5iC�[��k�����ߥQ�E��_�@\�A�b��������/d`���/�>����g9�������[����N�/����[�4_Z�|�J��P����ǿ���B~��~�{뤐O_���W=~w��RYZ�rf�cW��M&,����epȧ[�= ��<���p��m
R������u�F֯���j�դL��u�:EX(������www����>�����^.d��T:��.��Z�C�#�j�g���A<�fd��z3�L%�)��A�U39u�8`�׉�{��ӎL�eSs;}�Cw'R��6���f���3�0ҋv93�����˼\�uN�Y�2g!"[ӽ�:�Y���Cnݪ�K.�-J-�Jte�T�6��������/d �� �1���w����C�:p��J*O�!9��DLQ���(��Ȍ�D&�IA��/�|D�t��#�<$�~��U��5¯��*֫�-�Ex�egA����=�q)�g��9�vZ�s���ݩ5�)�t�[c����h��kӉ��n��t�
W�����8�Ƴ�$_)��z���vijb8럒�<2��Y���������X����ߍ����D`����3�����5�/O�O��w#4�����-M����S��&��o����o����?��ެ�cy6�82Ϥ8�2!%�OҜ�R*�RV�9I�96!91a8�g(!�.��4�S>���������� ��~e���7�s�+I��1��C?v:�m���V�o�y<���K���^ר:U����[��b�i����+Z�2;�X�{tN72����e�î���W�b�u5��ϳ��YQբ�F{�����}���0��o����� li���L������!���?�|�
�?�?j����? �����Ɗ���G�Y8�� ��!��ў�����_#4S�A�7�������?��Y�ۏ8��W��,��	`��a��Ѯ���7*��� �W���������Ѵ�C /���o����?����p�+*�������^�����ρ�o��&_��3��MД�����j@�A���?�<� ����6#�����/�������XDAS������5������������A����}�X�?���D���#��������������_P�!��`c0b�������������C.8p����9��n����o����o�����/p�c# ��Vٵ:��D������P/����7.��E�Ȥigy�ё�K��e\,r'�	�1�$l������Yl&�+�b���������O=� ��	�������ο-�����<ה��4+:YG�ހeͥ�j���޵���n�9�"�������p��
¤�*"X����*9�DO��� �w�$�TJ-k�{�m_�1�������'L���PMS�͆kx\�Ƴ�y�N&w8s6��)[!�O8���N�"�J���IFc�B8�+G�͘zC�W����s����l��u�(ge@���6��Iu���}���������y���C����u�^�?����?������w�� ��3��A�O�C����`�����0��?���@��������������z����w��?6���?��������:� ��c ����_/��t������9�F�?ARw�Oa����7�?.��(�t]�e���%8��lPh�����+�����7�?���d�z�-�}�yH'ߐ$q�����I�ܡ�`�RMCg��f�2�]�C��M�G����o�M���������+�d�jԹx�v��}9jJBõmmأ5��@�V�j^��.s)l���-G�K�yJ�,��IK�`����Z˴�<wrC�|�b��oc�߅^�?���:� ��c ����_��t���)H�L�8�tS���d�`C?"���A�=!<4�#*�ɡ��(���5��A�Gw���Ȣ�w��=�xr�,��[����r�Y��:��v���z�9���N��N��`ڰz�a�բ�a!#���qw�-��=�ܠ��(h�"���`���0c��m0�FSߵ���4\���������0:|O��?��G��k���>���?J������?��_y�I� ����������V���?�0"�CT8�� �I$1N{�0�j��>u5}�L�̐@F��nD���A����������V�;��:��,���Q��܆J���9��ĥ�V��M���͗�GC�Oəݮw�zd���V��L����\�P��/�ZOp(���H�P�S%"���g~(�-9oRr�_T)/5����������-���\�E[�������hp��
���҄[�W�u�k���yrS3�ԉITw�_n���Fk~�������*������tϗ�^�|A������z��ɯ���-kK��|iYS��T����sg݄��e�r\󶀺�'�WT��{ag����˨���4�����I#��x�=�^����8}9���Fh��Y�z� �]6�)���g�tB�$zB��&�����N-��2�g1���M�t6,��k�
��¾��)������l�P��0�çb3��,�r�C�j�6ʤ��%n�4*<Y��A��v%�&�љ����dQb�x����O����ÿp�G8�k������ZA���_ ���5������2���'B�A[��������&��_+x��g|;�	f���`��*'1�GB��2����O=���󟢑�/3�/;����3�G6ȲJ9O7OHuFe�G{n*D֜�ŏ�I��EuTcM˄�eWL5�¹��rN�ӭ��܅��}^�J×Y,s2.y�3*v�r�c.E�e��u���:Ƈ�XV��^�Ȥ�s���ɬ�I�C�z_.��f�QX�H���2�d��쩮��!��^�	_���A����1� ���t�q�`l�dS�ҵ�l|�<��|��Z�)K�U���ީ'��,]FSȊ�1�DX��n�t�?���[��C_��������6�� ䷿ ��c�>�?��ݡM�/	�M�O�����}�����#����7�?����!������ ����E4T�yich����6A�����3m��u�7Z&6�i���ۿ�ث���8p��캁\�:/nY?�;�n�i,0x��H�	c9H&cQfCs��k~�A��R�w�� �9|i��wy��|�ࣵ)�9&Z�f�:�Y��M�K��De����Y�}��1��9�h�_�����w0iB-��#"V9�AvT�c����k?�a�!N��x�Oأ4�Gg�4��X��ꈻ{^�W��U�=���Ǥɦ"�M}o�1?E��)����e��)6_؛���X&P4�K"�����;B��h�����`�M�@�����?������Nޛ�l�z\��*�t��A|���������|�����ޡ����	� m�4�[k���\�##i���<*�Y��9r��j��e��1��Np�؋��Ul�@3��W����������|�x�˃E*%�h��t�1a|*ӊ�I���ҘP�w��a�
��}����C%�k�lyJ��a�"�/S�*��ZB6-���1zJ�D.]���kd�G~�;ML�PXB����'���.B�?��Z� ܻg ��?�����������߃�0��
�����?�A�!ԃ�/
�_x��d��o����({5��4�U���j��nE���ۯ[�!������۟�3����
��\��g�al����x��?�#h[*��q��ַ6*�n�,s�2����'(Ց��X8c�\�����TB'1������a�Ut2��]��ŏ����?ׁu~�J�X�O{3�W	2�6�K���j�D�k]��ŝǻ���gd��*8Ѫ�s8��YB4$I�0��3��Af�p�6���C�=����[AW�h�~���A�M���V �@�����O��`��3tZ�������t�?<�!������;��9X>�G��u�r]�4��l��%A�������hqG��{��
�Ȭ��V�lE^#^��$y���1���;�c��jU��,��=�!YUUJ�Xs��ߝ�}w�7������`ju��2⫧h��l�.+����4.��l�5�>��/�jI��=~�(w�gRJ�˭�Z��0j��OA�����w �E��U��/����& ��� �[����1��#�����7�����Ow �P��P����?��J������Xݾd���_������?� ��z���]�'�`���@;����z������!��i��m�+�;������;��n�'�����?(
v������W���V ����������kS���p� ��[���������
��`���������������m�?0� ����_/���q��m�{��{���^����ǀ�oo������W���`��*'1�GB��2�������G�����~�4�F�+�{?�޽�	���� �*�<�<!��aZ���Ys�
?.'YV�Q�5-�1\1� 
�Jd��9YN��NDs�"�y�+_f��ɸ��:�Q!���o.EAx޲�z���z�����W_��r���ɬ�I�C�z_.��f�QX�H���2�d��쩮��!�����*��D�3�-"<�]c�#[7�T�t-!4Ϩ<_�<�l�RsF$e�w�I �K���bcFL$V��s�/���B/�� �������_���8D��w��?���������ϭ�s��b&b�c<��1��(/�i��S2萤P/��0��8"A��WkHF(=�����?�c�!���)���I����+�?7&���|�E����W+��(y���ƻ��z"�0m�K��D�5G�P�:��G�2�:��6M)̽�{k�����<�����*T��|�nW�7�渃x��	A{���/���el��|�8�-*����O�+��pT�$���D�j��T�/x�Ї�?J��?p�o	��?_ ʼ=E����?����i��A�G+h��?��/�+ ���5�c��OP�i��?�����w���]�?��l	}���������DA����O��	�?A�g����A��t��@T� ��c�^�?�����z����w�^���O
� �O �	�?���n������VЩ�!P������z�����?���z��'m�������w�7���[������K�K�D�ᙳK'0�g�6���v��4җo��=[cl�����)��mvƟ_D��_^P����AOXW�'�4�b������dLI������"������f�ќ͵9T���)]I�q�`z���c����M�İӥ�RUb!y���e�X]`;�u%@���T�՗}%��r�5ׇ���/�4��Ց�/�?�x����g�������C�<�v��[�pA4\���*ΫmI�Ɣ&�DV�l����MY%3/3�T��р��1Ͷ�Xn�U`H\���r'������?;B���@u��?�������?0��
����q�yA�F11�b��$�$��T@��M�9D)l8���0�B��@ԯ���(���0��-�w�?!�.Ϧ4����"����C�sbOU�.��x,U��ك��O����ʹ�(�y�H�G��p���O�P�'�d2[��tr_�39!d�:�`0|��	.��ĩ��:��SW����?�����>%���������o|�Q�����hp����_���`߫��O�)�?�Oqz��O��P�������O�f����[oVAUT�����{�G��vf6�=wvv�
�3iD0�ef�͌]eW��z�U.?��G��r�\e���]�W+�D	A��@�|BV"$�"R�A|D �X�P�	���HH+�*���~��lfJ|Zj��=�֭S��s�9�^O�6��Ҏ�:zL�z��YC]�������b��>�
G�����$!��	���O$~㕝��vb7nļ@��^����a�쬔 ��v������m�8R�0ΝY����y�m�^�=g���1�a,?��aO�L}[�Dl���Y���ݻƒ|~,��Nl8v�1c=e�ڧ�/�,��1}��Q,K�|��'�/�S�Ļ��S�ѝ�q���jǍ���I�� ���ީ��訡�`��:���=��c����v�
�ܫ2�T��'T��P������������\��w��H�w���ޡ@ݰ�up'���0q�h��x�1u9��n�#������Vc��>~�f��di����ڝ�4�Gѵ����5:���ʎ�v��wڽp̑,�	zwNP~��x����;5��H�h4�#h
E�N���f�/ �q��[�/n}��?��ڹ�b�_�q]E5CCQUO%Ԍ�F����4I+XRE����SpR5��j��%T\O��c8���Q��E����4?�������g��/��Ͽ��q��yppS�}\&<�g����]O�b��2=��^|�U.9������� pUX�A��W�A�}�p�ӭs��9t��mpq!�>tzf���_=�=UZ��C�BW��K������P�^��{=�e��m�"������������'�:��[�s�����t�U�R;WF㡾v���(p�9ſc��[�r�x�<�`��N������{`g;v饻���������T������q��v�͎����5
���+�7%0��:w�\8W����\qy���Pp-��^|	ÒmCgUm'54��4�P҆�R�t*	km��'�D
K�h2���6�Ɠz
A���CI�.�_��?��m��>�'������_��K�?��?��#���O���Ň޾���	R��7�o\;��\�����Bt�[�Co?��s�߹��8�����A�갞�B��9������ݦz,�ҏ;���~��ef�93>�8���-p�	HA���9Q�taƉ���%��ً�`Uf��j~@-c�9&(�Ҝ��^�cQ$�֐���[��zM��sdm��S�,!�1(0�Y���J�l��L�#�e�W����hn�
��r5p2���W��K�L�C�Z�l���bI3�9���f`��¸��8?WM̘���$;,1CRܷ��^39�'� T�~�7XN�XO��"��	�I�&Z�4wAb���&]�����zR$�(��Q�e�f�")�*)8��C-��[6Z�y׌���1-�w�_�,�^��������&���C�Ԥ�H�nyP��f> ����H�R���<m]��
�O-�d-vHp�D���~�h2���\"�'�Y��x��s�'"Ud;�*�]JUV��$��3<G�KF����{jw��Ċ�9;��nP��`�ây��&D��ۖ��@tЪ�31�*�\�Z�S�b�y�sA5�D��*���ʴ[�]r�S��io7Y#���M����LΏ�{�lG`�ba�r/�e�6��	d?���͈)(�>�r�E�$�L6[��k<̷��'A��wRz9Α���M�T��ȇp�N[ �-��HT��v��Yr�)6���8��(�ݰ�R.��b���[>q���ǫڸ;�S�j��2is�r�N��^^��Mci<�6�i��3��,SNv��,kf[�6P���4R�q�&�MX6*�H�T'��䘚�ؙj�������d��v��`9Vjy3���1Q�q���9��W�r��dBpz�c�r��̒�kL�<6�R�D/pN]q3�����8�w�S�s^0�ln4$t���S��C���Ұԯ��nT�P�LUã�A̲��C�5kG��r���V�kX~";�*<h�M�蠉��Ȍ*�HρG�Ez�8�.�Ǒ%�͟��$�w��֓�8_r�����6!��iyl�h"�z=.�l�,�Z/gACȳ�I�=[��]�A�����!�:R��5��&�N��mI򒭊0�(��r�ԟ`��<6p4��Q���z"�k!�r�`]�zU�����$��wX����JW��}w5+��D6> �(�mf���04�j���Y��&�sl����B����˨���HP��ת^">)&G=�M�3S;;�]�qe�Г�$7O���xR�t1��b�{Kѝ��R����W�נ-�b�y~�����u�<^��W��χ�YkpemA�n��&>�M�W�п=s�&��3�_��4�_�}�
�GW*n���#�{%��Ŏ.Ҭ]+���X��{�,��1���n��x?�tMJ�M�A& gg�]K�f�ۭ�ܦ���H��Ġ^��MWy�VA:�!���6�{�8�SR��4� ���X�1r��x�{a��9Q��X{W7�=̍�����bˆE���95�S�/'3���{>4ޙh�j��e�@s��|���͑�����j0��;;R^���,��M�]�Q�4��hY��d��}�һ)�p�vE4���Ǭb	��O�}^�r���b�*�};.U�1���=5U��*6^�����<!)��4&|ٚ�jɱܜp%`t��1"=�Z�ӒP���y����J�Ffni|��{�Tz)��T�|���~�q���'a��4~Vof� k�r�kL�F:f=u��%]N�����R�_���_�;h�</��g����9L��3@.��ܛ򮤉��UȼPd�<`Sd5UnXm�(��wM�"��b�w�b�T�v<G-���:U�g�3�y�����X�6\��ڍ:_��?݅~t����b��[�߾���o܄��&�������)fs������'�K��P��g�z��$k��@�By����&��`������j��ٝl�0	��$0`�ɮDUv�x;��-�3����yj*dDM�sn���kj}T��av�r��c�:���`l��ʍ��ąG�P��O`ʨl�G8#����OyN<�7�C>	?�t�oR���xq6���n�a&��^���lQX��m�W�V�pB����%B���Ͳ_l�.�(2�gP�V�xE�&�t�m>�i6q�����sl��8�Om�c�z������'�[��n��g�~�S��W/6�z������2�^�[�G��A�k^�g���={����go��\�gn��h���G�����R;��}��_W�A��Ǿ8�t�*t<�=w� E���Ԏ`�u�9���z��������ֺyz�#Z}������B�D�+��9 ص#���8���v$�xg�׏f#�p^ϒQ⮬�,m��|Z+R� WC=ܱ��n���CP��=��o��,������@��"�8��֏Bxv����{�д����� m����x��8�WD�O,�6��l`��6��l`�I��_��� � 