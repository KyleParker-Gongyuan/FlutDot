GDPC                                                                               <   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex0      �      &�y���ڞu;>��.p   res://DemoScene.gd.remap�'      $       M4�c��3�g�U4   res://DemoScene.gdc 0      p      ~vˎT��H��B�Y�   res://DemoScene.tscn�      Y      ZL��%k�1�۹��I�   res://Player.gd.remap   (      !       ��0�F �qq��dX��   res://Player.gdc       ;      jK�}��c6�P��jGS   res://Server.gd.remap   @(      !       �lلL=4�����   res://Server.gdc@      7      A2)^?pߤկ�A.�$)   res://default_env.tres  �      �       um�`�N��<*ỳ�8   res://icon.png  p(      �      G1?��z�c��vN��   res://icon.png.import   %      �      �d��?S���4m���   res://project.binary`5      J      B�8�!��y��G�e��        GDSC   &      m   �     ������ڶ   ������������ڶ��   ������¶   ��������������¶   ����   ��Ķ   �����϶�   ������¶   ����   �������Ӷ���   ���¶���   ��Ķ   �������������ڶ�   ����   ����������Ŷ   �������׶���   ̶��   �������Ķ���   ���������¶�   ������������������Ў����   ������Ҷ   ��������ض��   ���������Ҷ�   ����ٶ��   ���������¶�   �����Ў�   ��������׶��   �����¶�   �������Ŷ���   �����׶�   ���ڶ���   ������Ŷ   ��Ŷ   ������Ӷ   ��������   ������������   ���������Ӷ�   ������Ҷ      ws://127.0.0.1:5000              connection_closed         _closed       connection_error      connection_established     
   _connected        data_received         _on_data      Label         started server        Unable to connect                getting data            Got data from server:         we fr got the data        Closed, clean:               Connected with protocol:          command       ping      val       name       {"command":"ping", "val":"name"}      Sending packet     @  

func parser(packet): # parses JSON received from server
	# check packet is actually JSON
	if typeof(packet) != 18:
		# exit if not
		print("Wrong data type")
		return
	# get ping reply
	if packet.command == "ping": ## The server wants to check we are alive
		if ws == null:# or myID == null:
			return
		if ws.get_peer(1).is_connected_to_host():
			ws.get_peer(1).put_packet(to_json({"command":"pong","id":myID}).to_utf8())
		else:
			return
	if packet.command == "pong": ## the server replied when we checked it was alive
		# we just get the timestamp we send back, so just sub that from the current time
		var diff = (OS.get_unix_time() - int(packet.val))
		print("Ping took "+str(diff)+" secs")
	# get own ID
	elif packet.command == "getID": # we got our intial ID from the server
		print("GOT ID "+packet.val)
		myID = packet.val 
		Clients[myID] = {}
		var col = $UI/Menu/ColorPicker.getColour()
		$Room/Player.setMod({"r":col.r,"g":col.g,"b":col.b})
		if ws == null or myID == null:
			return
		if ws.get_peer(1).is_connected_to_host():
			ws.get_peer(1).put_packet(to_json({"command":"reg","id":myID,"user":$UI/Menu/LineEdit.text,"col":{"r":col.r,"g":col.g,"b":col.b}}).to_utf8())
		else:
			return 
	# get chat 
	elif packet.command == "chat": 
		$UI/Chat.doChat(packet.val)
	# get the clients list from server (and everything else)

      server pinged us      s         dad                                                  	   	      
                                  !      '      (      3      >      I      J      K      L      M      X      Y      a      g      h      i      j       k   !   l   "   v   #   |   $   �   %   �   &   �   '   �   (   �   )   �   *   �   +   �   ,   �   -   �   .   �   /   �   0   �   1   �   2   �   3   �   4   �   5   �   6   �   7   �   8   �   9   �   :   �   ;   �   <   �   =   �   >   �   ?   �   @   �   A   �   B   �   C   �   D   �   E     F     G     H     I   $  J   %  K   8  L   9  M   @  N   A  O   B  P   H  Q   I  R   J  S   Q  T   R  U   W  V   g  W   r  X   s  Y   t  Z   �  [   �  \   �  ]   �  ^   �  _   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   3YYYYYYYY8;�  YYYY;�  �  T�  PQY;�  �  YY0�  PQV�  �  �  T�  P�  RR�  Q�  �  T�  P�  RR�  Q�  �  T�  P�  RR�  QY�  �  �  �  �  T�  P�  RR�  Q�  �  ;�  �	  P�	  Q�  �  T�
  �
  �  �  YY�  �  ;�  �  T�  P�  Q�  &�  �  V�  �?  P�  Q�  �  P�  QYY0�  PQV�  �  �  �  ;�  �	  P�	  Q�  �  T�
  �  �  ;�  �  T�  P�  QT�  PQT�  PQ�  �  �?  P�  R�>  P�  QQ�  �  �  �  �  T�
  �  �>  P�  Q�  �  �  �  �  YY0�  P�  �  QV�  �  �  �?  P�  R�  Q�  �  P�  QYY0�  P�  �  QV�  �  �  �?  P�  R�  Q�  �  �  �  �  T�  P�  QT�  P�Q  PN�  V�  R�  V�  OQT�  PQQ�  YYY0�  P�  �  QV�  �  �  T�  P�  QT�  P�>  P�  QT�  PQQYY0�  P�  QV�  �  �  �  T�  PQYYY0�  P�   QV�  �  ;�!  �  �  ;�  V�  �"  T�?  P�!  QT�  PQ�  �?  P�  R�  T�  PQQY�  �  �  T�  P�  QT�  P�  Q�  �  ;�  �	  P�	  Q�  �  T�
  �>  P�   QYY�  Y0�#  P�  QV�  ;�$  V�  �  T�%  �  /�$  V�  �  V�  �?  P�  Q�  ;�  �	  P�	  Q�  �  T�
  �  �  �  \V�  �?  P�  Q�  �  Y`[gd_scene load_steps=5 format=2]

[ext_resource path="res://DemoScene.gd" type="Script" id=1]
[ext_resource path="res://icon.png" type="Texture" id=2]
[ext_resource path="res://Player.gd" type="Script" id=3]

[sub_resource type="RectangleShape2D" id=1]
extents = Vector2( 65.25, 65 )

[node name="Spatial" type="Spatial"]
script = ExtResource( 1 )

[node name="Player" type="KinematicBody2D" parent="."]
position = Vector2( 350, 150 )
script = ExtResource( 3 )

[node name="CollisionShape2D" type="CollisionShape2D" parent="Player"]
shape = SubResource( 1 )

[node name="Icon" type="Sprite" parent="Player/CollisionShape2D"]
position = Vector2( -0.75, 0 )
scale = Vector2( 1.93359, 1.9375 )
texture = ExtResource( 2 )

[node name="Label" type="Label" parent="."]
margin_left = 545.0
margin_top = 86.0
margin_right = 585.0
margin_bottom = 100.0
text = "yep"
       GDSC   
         Q      ������������τ�   �����϶�   �����¶�   ����¶��   ��������������������ض��   �������ض���   ���������¶�   ������Ŷ   ζ��   ϶��   	   curPos==:         x         y                      	      
                           	      
   !      "      #      $      -      .      C      J      L      M      N      O      3YY0�  PQV�  �  -YYY0�  P�  QV�  &�  4�  V�  �  �  T�  �  �  �  �  �?  PR�  T�  Q�  �  �  PQT�  PN�  V�  T�  R�  V�  T�	  OQ�  �?  P�  T�  Q�  -YYYY`     GDSC      	       �      ���Ӷ���   ���ⶶ��   �����Ķ�   ������Ŷ   �����϶�   �����������������������¶���   ����   ������������Ķ��   �������Ӷ���   ������¶   �������������������Ҷ���   ����������������������Ҷ   ����������������¶��   �Ҷ�   ���׶���   �������Ŷ���   ����׶��   �     	   connected         _on_client_connected      network_peer_disconnected         _on_client_disconnected       network_peer_packet       _on_client_packet         Client connected:         Client disconnected:                             	                           	   !   
   .      9      D      O      P      V      [      \      ]      c      h      i      j      s      t      u      v      x      y      �      �      �       3YY:�  YY;�  Y;�  LMYY0�  PQV�  �  �  T�  PQ�  �  T�  P�  R�  T�  PQQ�  �  T�	  P�  RR�  Q�  �  T�	  P�  RR�  Q�  �  T�	  P�  RR�  QYY0�
  PQV�  �?  P�  Q�  YY0�  PQV�  �?  P�  Q�  YY0�  P�  R�  QV�  �  �  �  -YY0�  P�  QV�  �  -Y`         [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?����m��������_"�0@��^�"�v��s�}� �W��<f��Yn#I������wO���M`ҋ���N��m:�
��{-�4b7DԧQ��A �B�P��*B��v��
Q�-����^R�D���!(����T�B�*�*���%E["��M�\͆B�@�U$R�l)���{�B���@%P����g*Ųs�TP��a��dD
�6�9�UR�s����1ʲ�X�!�Ha�ߛ�$��N����i�a΁}c Rm��1��Q�c���fdB�5������J˚>>���s1��}����>����Y��?�TEDױ���s���\�T���4D����]ׯ�(aD��Ѓ!�a'\�G(��$+c$�|'�>����/B��c�v��_oH���9(l�fH������8��vV�m�^�|�m۶m�����q���k2�='���:_>��������á����-wӷU�x�˹�fa���������ӭ�M���SƷ7������|��v��v���m�d���ŝ,��L��Y��ݛ�X�\֣� ���{�#3���
�6������t`�
��t�4O��ǎ%����u[B�����O̲H��o߾��$���f���� �H��\��� �kߡ}�~$�f���N\�[�=�'��Nr:a���si����(9Lΰ���=����q-��W��LL%ɩ	��V����R)�=jM����d`�ԙHT�c���'ʦI��DD�R��C׶�&����|t Sw�|WV&�^��bt5WW,v�Ş�qf���+���Jf�t�s�-BG�t�"&�Ɗ����׵�Ջ�KL�2)gD� ���� NEƋ�R;k?.{L�$�y���{'��`��ٟ��i��{z�5��i������c���Z^�
h�+U�mC��b��J��uE�c�����h��}{�����i�'�9r�����ߨ򅿿��hR�Mt�Rb���C�DI��iZ�6i"�DN�3���J�zڷ#oL����Q �W��D@!'��;�� D*�K�J�%"�0�����pZԉO�A��b%�l�#��$A�W�A�*^i�$�%a��rvU5A�ɺ�'a<��&�DQ��r6ƈZC_B)�N�N(�����(z��y�&H�ض^��1Z4*,RQjԫ׶c����yq��4���?�R�����0�6f2Il9j��ZK�4���է�0؍è�ӈ�Uq�3�=[vQ�d$���±eϘA�����R�^��=%:�G�v��)�ǖ/��RcO���z .�ߺ��S&Q����o,X�`�����|��s�<3Z��lns'���vw���Y��>V����G�nuk:��5�U.�v��|����W���Z���4�@U3U�������|�r�?;�
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
           [remap]

path="res://DemoScene.gdc"
            [remap]

path="res://Player.gdc"
               [remap]

path="res://Server.gdc"
               �PNG

   IHDR   @   @   �iq�   sRGB ���  �IDATx��ytTU��?�ի%���@ȞY1JZ �iA�i�[P��e��c;�.`Ow+4�>�(}z�EF�Dm�:�h��IHHB�BR!{%�Zߛ?��	U�T�
���:��]~�������-�	Ì�{q*�h$e-
�)��'�d�b(��.�B�6��J�ĩ=;���Cv�j��E~Z��+��CQ�AA�����;�.�	�^P	���ARkUjQ�b�,#;�8�6��P~,� �0�h%*QzE� �"��T��
�=1p:lX�Pd�Y���(:g����kZx ��A���띊3G�Di� !�6����A҆ @�$JkD�$��/�nYE��< Q���<]V�5O!���>2<��f��8�I��8��f:a�|+�/�l9�DEp�-�t]9)C�o��M~�k��tw�r������w��|r�Ξ�	�S�)^� ��c�eg$�vE17ϟ�(�|���Ѧ*����
����^���uD�̴D����h�����R��O�bv�Y����j^�SN֝
������PP���������Y>����&�P��.3+�$��ݷ�����{n����_5c�99�fbסF&�k�mv���bN�T���F���A�9�
(.�'*"��[��c�{ԛmNު8���3�~V� az
�沵�f�sD��&+[���ke3o>r��������T�]����* ���f�~nX�Ȉ���w+�G���F�,U�� D�Դ0赍�!�B�q�c�(
ܱ��f�yT�:��1�� +����C|��-�T��D�M��\|�K�j��<yJ, ����n��1.FZ�d$I0݀8]��Jn_� ���j~����ցV���������1@M�)`F�BM����^x�>
����`��I�˿��wΛ	����W[�����v��E�����u��~��{R�(����3���������y����C��!��nHe�T�Z�����K�P`ǁF´�nH啝���=>id,�>�GW-糓F������m<P8�{o[D����w�Q��=N}�!+�����-�<{[���������w�u�L�����4�����Uc�s��F�륟��c�g�u�s��N��lu���}ן($D��ת8m�Q�V	l�;��(��ڌ���k�
s\��JDIͦOzp��مh����T���IDI���W�Iǧ�X���g��O��a�\:���>����g���%|����i)	�v��]u.�^�:Gk��i)	>��T@k{'	=�������@a�$zZ�;}�󩀒��T�6�Xq&1aWO�,&L�cřT�4P���g[�
p�2��~;� ��Ҭ�29�xri� ��?��)��_��@s[��^�ܴhnɝ4&'
��NanZ4��^Js[ǘ��2���x?Oܷ�$��3�$r����Q��1@�����~��Y�Qܑ�Hjl(}�v�4vSr�iT�1���f������(���A�ᥕ�$� X,�3'�0s����×ƺk~2~'�[�ё�&F�8{2O�y�n�-`^/FPB�?.�N�AO]]�� �n]β[�SR�kN%;>�k��5������]8������=p����Ցh������`}�
�J�8-��ʺ����� �fl˫[8�?E9q�2&������p��<�r�8x� [^݂��2�X��z�V+7N����V@j�A����hl��/+/'5�3�?;9
�(�Ef'Gyҍ���̣�h4RSS� ����������j�Z��jI��x��dE-y�a�X�/�����:��� +k�� �"˖/���+`��],[��UVV4u��P �˻�AA`��)*ZB\\��9lܸ�]{N��礑]6�Hnnqqq-a��Qxy�7�`=8A�Sm&�Q�����u�0hsPz����yJt�[�>�/ޫ�il�����.��ǳ���9��
_
��<s���wT�S������;F����-{k�����T�Z^���z�!t�۰؝^�^*���؝c
���;��7]h^
��PA��+@��gA*+�K��ˌ�)S�1��(Ե��ǯ�h����õ�M�`��p�cC�T")�z�j�w��V��@��D��N�^M\����m�zY��C�Ҙ�I����N�Ϭ��{�9�)����o���C���h�����ʆ.��׏(�ҫ���@�Tf%yZt���wg�4s�]f�q뗣�ǆi�l�⵲3t��I���O��v;Z�g��l��l��kAJѩU^wj�(��������{���)�9�T���KrE�V!�D���aw���x[�I��tZ�0Y �%E�͹���n�G�P�"5FӨ��M�K�!>R���$�.x����h=gϝ�K&@-F��=}�=�����5���s �CFwa���8��u?_����D#���x:R!5&��_�]���*�O��;�)Ȉ�@�g�����ou�Q�v���J�G�6�P�������7��-���	պ^#�C�S��[]3��1���IY��.Ȉ!6\K�:��?9�Ev��S]�l;��?/� ��5�p�X��f�1�;5�S�ye��Ƅ���,Da�>�� O.�AJL(���pL�C5ij޿hBƾ���ڎ�)s��9$D�p���I��e�,ə�+;?�t��v�p�-��&����	V���x���yuo-G&8->�xt�t������Rv��Y�4ZnT�4P]�HA�4�a�T�ǅ1`u\�,���hZ����S������o翿���{�릨ZRq��Y��fat�[����[z9��4�U�V��Anb$Kg������]������8�M0(WeU�H�\n_��¹�C�F�F�}����8d�N��.��]���u�,%Z�F-���E�'����q�L�\������=H�W'�L{�BP0Z���Y�̞���DE��I�N7���c��S���7�Xm�/`�	�+`����X_��KI��^��F\�aD�����~�+M����ㅤ��	SY��/�.�`���:�9Q�c �38K�j�0Y�D�8����W;ܲ�pTt��6P,� Nǵ��Æ�:(���&�N�/ X��i%�?�_P	�n�F�.^�G�E���鬫>?���"@v�2���A~�aԹ_[P, n��N������_rƢ��    IEND�B`�       ECFG
      application/config/name         Flutdot GoDot Demo     application/run/main_scene         res://DemoScene.tscn   application/config/icon         res://icon.png     editor_plugins/enabled          +   gui/common/drop_mouse_on_gui_input_disabled         )   physics/common/enable_pause_aware_picking         $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          )   rendering/environment/default_environment          res://default_env.tres        