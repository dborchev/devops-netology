# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"
https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-08-net/README.md

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
   1. похоже, авторы вопроса сами не пробовали ввести команды, данные в примере:
   ```cisco
   route-views>sh ip route 52.57.218.202/32
                                        ^
   % Invalid input detected at '^' marker.
   ```
   2. без длины префикса всё работает
   ```cisco
   route-views>sh ip route 52.57.218.202
   Routing entry for 52.57.0.0/16
      Known via "bgp 6447", distance 20, metric 10
      Tag 3257, type external
      Last update from 89.149.178.10 4w6d ago
      Routing Descriptor Blocks:
      * 89.149.178.10, from 89.149.178.10, 4w6d ago
          Route metric is 10, traffic share count is 1
          AS Hops 2
          Route tag 3257
          MPLS label: none
   ```
   3. аналогично, по очевидным причинам, маршрута `/32` не будет:
   ```cisco
   route-views>sh bgp 52.57.218.202/32
   % Network not in table
   ```
   однако, существует `/16`:
   ```cisco
   route-views>sh bgp 52.57.218.202
    BGP routing table entry for 52.57.0.0/16, version 272713803
    Paths: (23 available, best #22, table default)
      Not advertised to any peer
      Refresh Epoch 1
      3333 1103 16509
        193.0.0.56 from 193.0.0.56 (193.0.0.56)
          Origin IGP, localpref 100, valid, external
          path 7FE0463A0820 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      8283 16509
        94.142.247.3 from 94.142.247.3 (94.142.247.3)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 8283:1 8283:101 8283:102 8283:103
          unknown transitive attribute: flag 0xE0 type 0x20 length 0x30
            value 0000 205B 0000 0000 0000 0001 0000 205B
                  0000 0005 0000 0001 0000 205B 0000 0005
                  0000 0002 0000 205B 0000 0005 0000 0003
    
          path 7FE02EA18158 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      1351 6939 16509 16509
        132.198.255.253 from 132.198.255.253 (132.198.255.253)
          Origin IGP, localpref 100, valid, external
          path 7FE0351F32C8 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      852 3257 16509
        154.11.12.212 from 154.11.12.212 (96.1.209.43)
          Origin IGP, metric 0, localpref 100, valid, external
          path 7FE18543B228 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      57866 6830 16509
        37.139.139.17 from 37.139.139.17 (37.139.139.17)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 6830:17000 6830:17480 6830:33125 17152:0 57866:501
          path 7FE09C77DCF0 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20130 6939 16509 16509
        140.192.8.16 from 140.192.8.16 (140.192.8.16)
          Origin IGP, localpref 100, valid, external
          path 7FE175D64510 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3549 3356 16509
        208.51.134.254 from 208.51.134.254 (67.16.168.191)
          Origin IGP, metric 13855, localpref 100, valid, external
          Community: 3549:666 3549:2352 3549:31826
          path 7FE039F3CA88 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      701 174 16509
        137.39.3.55 from 137.39.3.55 (137.39.3.55)
          Origin IGP, localpref 100, valid, external
          path 7FE125445908 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      53767 174 16509
        162.251.163.2 from 162.251.163.2 (162.251.162.3)
          Origin IGP, localpref 100, valid, external
          Community: 174:21101 174:22012 53767:5000
          path 7FE0503BA518 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3356 6453 16509
        4.68.4.46 from 4.68.4.46 (4.69.184.201)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 3356:3 3356:86 3356:576 3356:666 3356:901 3356:2012 6453:2000 6453:2100 6453:2101
          path 7FE0E4967350 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      4901 6079 3257 16509
        162.250.137.254 from 162.250.137.254 (162.250.137.254)
          Origin IGP, localpref 100, valid, external
          Community: 65000:10100 65000:10300 65000:10400
          path 7FE0188156F8 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20912 16509
        212.66.96.126 from 212.66.96.126 (212.66.96.126)
          Origin IGP, localpref 100, valid, external
          Community: 20912:65016
          path 7FE0D8CE1DB0 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3303 16509
        217.192.89.50 from 217.192.89.50 (138.187.128.158)
          Origin IGP, localpref 100, valid, external
          Community: 3303:1004 3303:1007 3303:3067
          path 7FE0F1E4F3A0 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      7018 1299 16509
        12.0.1.63 from 12.0.1.63 (12.0.1.63)
          Origin IGP, localpref 100, valid, external
          Community: 7018:5000 7018:37232
          path 7FE01EFA8B98 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      7660 2516 3257 16509
        203.181.248.168 from 203.181.248.168 (203.181.248.168)
          Origin IGP, localpref 100, valid, external
          Community: 2516:1030 7660:9003
          path 7FE091424D20 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3561 209 3356 174 16509
        206.24.210.80 from 206.24.210.80 (206.24.210.80)
          Origin IGP, localpref 100, valid, external
          path 7FE012C2F3B0 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      6939 16509 16509
        64.71.137.241 from 64.71.137.241 (216.218.252.164)
          Origin IGP, localpref 100, valid, external
          path 7FE08789B990 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      101 2914 16509
        209.124.176.223 from 209.124.176.223 (209.124.176.223)
          Origin IGP, localpref 100, valid, external
          Community: 101:20100 101:20110 101:22100 2914:410 2914:1203 2914:2201 2914:3200
          Extended Community: RT:101:22100
          path 7FE0CF4FC2C8 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 2
      2497 16509
        202.232.0.2 from 202.232.0.2 (58.138.96.254)
          Origin IGP, localpref 100, valid, external
          path 7FE0AA2F1C28 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      49788 16509
        91.218.184.60 from 91.218.184.60 (91.218.184.60)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 49788:1000
          path 7FE011303350 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      1221 4637 16509
        203.62.252.83 from 203.62.252.83 (203.62.252.83)
          Origin IGP, localpref 100, valid, external
          path 7FE0DF3040D8 RPKI State valid
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3257 16509
        89.149.178.10 from 89.149.178.10 (213.200.83.26)
          Origin IGP, metric 10, localpref 100, valid, external, best
          Community: 3257:4000 3257:6530 3257:8133 3257:50001 3257:50110 3257:54901
          path 7FE1657B2E60 RPKI State valid
          rx pathid: 0, tx pathid: 0x0
      Refresh Epoch 1
      19214 3257 16509
        208.74.64.40 from 208.74.64.40 (208.74.64.40)
          Origin IGP, localpref 100, valid, external
          Community: 3257:4000 3257:6530 3257:8027 3257:50001 3257:50110 3257:54400 3257:54401
          path 7FE02AF2E730 RPKI State valid
          rx pathid: 0, tx pathid: 0
   ```
