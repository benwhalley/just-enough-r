
---
title: 'Colours'
---



## Colours {-}

### Picking colours for plots {- #picking-colours}

See https://www.perceptualedge.com/articles/b-eye/choosing_colors.pdf for an
interesting discussion on picking colours for data visualisation.

Also check the
[ggplots docs for colour brewer](http://ggplot2.tidyverse.org/reference/scale_brewer.html)
and the [Colour Brewer website](http://colorbrewer2.org/).

### Named colours in R {- #named-colours}


```r
print.col <- Vectorize(function(col){
  rgb <- grDevices::col2rgb(col)
  sprintf("<span style='padding:1em; background-color: rgb(%s, %s, %s);'>&nbsp;</span> %s \n\n", rgb[1], rgb[2], rgb[3], col,  rgb[1], rgb[2], rgb[3])
})

pandoc.p(print.col(colours()))
```



<span style='padding:1em; background-color: rgb(255, 255, 255);'>&nbsp;</span> white 


<span style='padding:1em; background-color: rgb(240, 248, 255);'>&nbsp;</span> aliceblue 


<span style='padding:1em; background-color: rgb(250, 235, 215);'>&nbsp;</span> antiquewhite 


<span style='padding:1em; background-color: rgb(255, 239, 219);'>&nbsp;</span> antiquewhite1 


<span style='padding:1em; background-color: rgb(238, 223, 204);'>&nbsp;</span> antiquewhite2 


<span style='padding:1em; background-color: rgb(205, 192, 176);'>&nbsp;</span> antiquewhite3 


<span style='padding:1em; background-color: rgb(139, 131, 120);'>&nbsp;</span> antiquewhite4 


<span style='padding:1em; background-color: rgb(127, 255, 212);'>&nbsp;</span> aquamarine 


<span style='padding:1em; background-color: rgb(127, 255, 212);'>&nbsp;</span> aquamarine1 


<span style='padding:1em; background-color: rgb(118, 238, 198);'>&nbsp;</span> aquamarine2 


<span style='padding:1em; background-color: rgb(102, 205, 170);'>&nbsp;</span> aquamarine3 


<span style='padding:1em; background-color: rgb(69, 139, 116);'>&nbsp;</span> aquamarine4 


<span style='padding:1em; background-color: rgb(240, 255, 255);'>&nbsp;</span> azure 


<span style='padding:1em; background-color: rgb(240, 255, 255);'>&nbsp;</span> azure1 


<span style='padding:1em; background-color: rgb(224, 238, 238);'>&nbsp;</span> azure2 


<span style='padding:1em; background-color: rgb(193, 205, 205);'>&nbsp;</span> azure3 


<span style='padding:1em; background-color: rgb(131, 139, 139);'>&nbsp;</span> azure4 


<span style='padding:1em; background-color: rgb(245, 245, 220);'>&nbsp;</span> beige 


<span style='padding:1em; background-color: rgb(255, 228, 196);'>&nbsp;</span> bisque 


<span style='padding:1em; background-color: rgb(255, 228, 196);'>&nbsp;</span> bisque1 


<span style='padding:1em; background-color: rgb(238, 213, 183);'>&nbsp;</span> bisque2 


<span style='padding:1em; background-color: rgb(205, 183, 158);'>&nbsp;</span> bisque3 


<span style='padding:1em; background-color: rgb(139, 125, 107);'>&nbsp;</span> bisque4 


<span style='padding:1em; background-color: rgb(0, 0, 0);'>&nbsp;</span> black 


<span style='padding:1em; background-color: rgb(255, 235, 205);'>&nbsp;</span> blanchedalmond 


<span style='padding:1em; background-color: rgb(0, 0, 255);'>&nbsp;</span> blue 


<span style='padding:1em; background-color: rgb(0, 0, 255);'>&nbsp;</span> blue1 


<span style='padding:1em; background-color: rgb(0, 0, 238);'>&nbsp;</span> blue2 


<span style='padding:1em; background-color: rgb(0, 0, 205);'>&nbsp;</span> blue3 


<span style='padding:1em; background-color: rgb(0, 0, 139);'>&nbsp;</span> blue4 


<span style='padding:1em; background-color: rgb(138, 43, 226);'>&nbsp;</span> blueviolet 


<span style='padding:1em; background-color: rgb(165, 42, 42);'>&nbsp;</span> brown 


<span style='padding:1em; background-color: rgb(255, 64, 64);'>&nbsp;</span> brown1 


<span style='padding:1em; background-color: rgb(238, 59, 59);'>&nbsp;</span> brown2 


<span style='padding:1em; background-color: rgb(205, 51, 51);'>&nbsp;</span> brown3 


<span style='padding:1em; background-color: rgb(139, 35, 35);'>&nbsp;</span> brown4 


<span style='padding:1em; background-color: rgb(222, 184, 135);'>&nbsp;</span> burlywood 


<span style='padding:1em; background-color: rgb(255, 211, 155);'>&nbsp;</span> burlywood1 


<span style='padding:1em; background-color: rgb(238, 197, 145);'>&nbsp;</span> burlywood2 


<span style='padding:1em; background-color: rgb(205, 170, 125);'>&nbsp;</span> burlywood3 


<span style='padding:1em; background-color: rgb(139, 115, 85);'>&nbsp;</span> burlywood4 


<span style='padding:1em; background-color: rgb(95, 158, 160);'>&nbsp;</span> cadetblue 


<span style='padding:1em; background-color: rgb(152, 245, 255);'>&nbsp;</span> cadetblue1 


<span style='padding:1em; background-color: rgb(142, 229, 238);'>&nbsp;</span> cadetblue2 


<span style='padding:1em; background-color: rgb(122, 197, 205);'>&nbsp;</span> cadetblue3 


<span style='padding:1em; background-color: rgb(83, 134, 139);'>&nbsp;</span> cadetblue4 


<span style='padding:1em; background-color: rgb(127, 255, 0);'>&nbsp;</span> chartreuse 


<span style='padding:1em; background-color: rgb(127, 255, 0);'>&nbsp;</span> chartreuse1 


<span style='padding:1em; background-color: rgb(118, 238, 0);'>&nbsp;</span> chartreuse2 


<span style='padding:1em; background-color: rgb(102, 205, 0);'>&nbsp;</span> chartreuse3 


<span style='padding:1em; background-color: rgb(69, 139, 0);'>&nbsp;</span> chartreuse4 


<span style='padding:1em; background-color: rgb(210, 105, 30);'>&nbsp;</span> chocolate 


<span style='padding:1em; background-color: rgb(255, 127, 36);'>&nbsp;</span> chocolate1 


<span style='padding:1em; background-color: rgb(238, 118, 33);'>&nbsp;</span> chocolate2 


<span style='padding:1em; background-color: rgb(205, 102, 29);'>&nbsp;</span> chocolate3 


<span style='padding:1em; background-color: rgb(139, 69, 19);'>&nbsp;</span> chocolate4 


<span style='padding:1em; background-color: rgb(255, 127, 80);'>&nbsp;</span> coral 


<span style='padding:1em; background-color: rgb(255, 114, 86);'>&nbsp;</span> coral1 


<span style='padding:1em; background-color: rgb(238, 106, 80);'>&nbsp;</span> coral2 


<span style='padding:1em; background-color: rgb(205, 91, 69);'>&nbsp;</span> coral3 


<span style='padding:1em; background-color: rgb(139, 62, 47);'>&nbsp;</span> coral4 


<span style='padding:1em; background-color: rgb(100, 149, 237);'>&nbsp;</span> cornflowerblue 


<span style='padding:1em; background-color: rgb(255, 248, 220);'>&nbsp;</span> cornsilk 


<span style='padding:1em; background-color: rgb(255, 248, 220);'>&nbsp;</span> cornsilk1 


<span style='padding:1em; background-color: rgb(238, 232, 205);'>&nbsp;</span> cornsilk2 


<span style='padding:1em; background-color: rgb(205, 200, 177);'>&nbsp;</span> cornsilk3 


<span style='padding:1em; background-color: rgb(139, 136, 120);'>&nbsp;</span> cornsilk4 


<span style='padding:1em; background-color: rgb(0, 255, 255);'>&nbsp;</span> cyan 


<span style='padding:1em; background-color: rgb(0, 255, 255);'>&nbsp;</span> cyan1 


<span style='padding:1em; background-color: rgb(0, 238, 238);'>&nbsp;</span> cyan2 


<span style='padding:1em; background-color: rgb(0, 205, 205);'>&nbsp;</span> cyan3 


<span style='padding:1em; background-color: rgb(0, 139, 139);'>&nbsp;</span> cyan4 


<span style='padding:1em; background-color: rgb(0, 0, 139);'>&nbsp;</span> darkblue 


<span style='padding:1em; background-color: rgb(0, 139, 139);'>&nbsp;</span> darkcyan 


<span style='padding:1em; background-color: rgb(184, 134, 11);'>&nbsp;</span> darkgoldenrod 


<span style='padding:1em; background-color: rgb(255, 185, 15);'>&nbsp;</span> darkgoldenrod1 


<span style='padding:1em; background-color: rgb(238, 173, 14);'>&nbsp;</span> darkgoldenrod2 


<span style='padding:1em; background-color: rgb(205, 149, 12);'>&nbsp;</span> darkgoldenrod3 


<span style='padding:1em; background-color: rgb(139, 101, 8);'>&nbsp;</span> darkgoldenrod4 


<span style='padding:1em; background-color: rgb(169, 169, 169);'>&nbsp;</span> darkgray 


<span style='padding:1em; background-color: rgb(0, 100, 0);'>&nbsp;</span> darkgreen 


<span style='padding:1em; background-color: rgb(169, 169, 169);'>&nbsp;</span> darkgrey 


<span style='padding:1em; background-color: rgb(189, 183, 107);'>&nbsp;</span> darkkhaki 


<span style='padding:1em; background-color: rgb(139, 0, 139);'>&nbsp;</span> darkmagenta 


<span style='padding:1em; background-color: rgb(85, 107, 47);'>&nbsp;</span> darkolivegreen 


<span style='padding:1em; background-color: rgb(202, 255, 112);'>&nbsp;</span> darkolivegreen1 


<span style='padding:1em; background-color: rgb(188, 238, 104);'>&nbsp;</span> darkolivegreen2 


<span style='padding:1em; background-color: rgb(162, 205, 90);'>&nbsp;</span> darkolivegreen3 


<span style='padding:1em; background-color: rgb(110, 139, 61);'>&nbsp;</span> darkolivegreen4 


<span style='padding:1em; background-color: rgb(255, 140, 0);'>&nbsp;</span> darkorange 


<span style='padding:1em; background-color: rgb(255, 127, 0);'>&nbsp;</span> darkorange1 


<span style='padding:1em; background-color: rgb(238, 118, 0);'>&nbsp;</span> darkorange2 


<span style='padding:1em; background-color: rgb(205, 102, 0);'>&nbsp;</span> darkorange3 


<span style='padding:1em; background-color: rgb(139, 69, 0);'>&nbsp;</span> darkorange4 


<span style='padding:1em; background-color: rgb(153, 50, 204);'>&nbsp;</span> darkorchid 


<span style='padding:1em; background-color: rgb(191, 62, 255);'>&nbsp;</span> darkorchid1 


<span style='padding:1em; background-color: rgb(178, 58, 238);'>&nbsp;</span> darkorchid2 


<span style='padding:1em; background-color: rgb(154, 50, 205);'>&nbsp;</span> darkorchid3 


<span style='padding:1em; background-color: rgb(104, 34, 139);'>&nbsp;</span> darkorchid4 


<span style='padding:1em; background-color: rgb(139, 0, 0);'>&nbsp;</span> darkred 


<span style='padding:1em; background-color: rgb(233, 150, 122);'>&nbsp;</span> darksalmon 


<span style='padding:1em; background-color: rgb(143, 188, 143);'>&nbsp;</span> darkseagreen 


<span style='padding:1em; background-color: rgb(193, 255, 193);'>&nbsp;</span> darkseagreen1 


<span style='padding:1em; background-color: rgb(180, 238, 180);'>&nbsp;</span> darkseagreen2 


<span style='padding:1em; background-color: rgb(155, 205, 155);'>&nbsp;</span> darkseagreen3 


<span style='padding:1em; background-color: rgb(105, 139, 105);'>&nbsp;</span> darkseagreen4 


<span style='padding:1em; background-color: rgb(72, 61, 139);'>&nbsp;</span> darkslateblue 


<span style='padding:1em; background-color: rgb(47, 79, 79);'>&nbsp;</span> darkslategray 


<span style='padding:1em; background-color: rgb(151, 255, 255);'>&nbsp;</span> darkslategray1 


<span style='padding:1em; background-color: rgb(141, 238, 238);'>&nbsp;</span> darkslategray2 


<span style='padding:1em; background-color: rgb(121, 205, 205);'>&nbsp;</span> darkslategray3 


<span style='padding:1em; background-color: rgb(82, 139, 139);'>&nbsp;</span> darkslategray4 


<span style='padding:1em; background-color: rgb(47, 79, 79);'>&nbsp;</span> darkslategrey 


<span style='padding:1em; background-color: rgb(0, 206, 209);'>&nbsp;</span> darkturquoise 


<span style='padding:1em; background-color: rgb(148, 0, 211);'>&nbsp;</span> darkviolet 


<span style='padding:1em; background-color: rgb(255, 20, 147);'>&nbsp;</span> deeppink 


<span style='padding:1em; background-color: rgb(255, 20, 147);'>&nbsp;</span> deeppink1 


<span style='padding:1em; background-color: rgb(238, 18, 137);'>&nbsp;</span> deeppink2 


<span style='padding:1em; background-color: rgb(205, 16, 118);'>&nbsp;</span> deeppink3 


<span style='padding:1em; background-color: rgb(139, 10, 80);'>&nbsp;</span> deeppink4 


<span style='padding:1em; background-color: rgb(0, 191, 255);'>&nbsp;</span> deepskyblue 


<span style='padding:1em; background-color: rgb(0, 191, 255);'>&nbsp;</span> deepskyblue1 


<span style='padding:1em; background-color: rgb(0, 178, 238);'>&nbsp;</span> deepskyblue2 


<span style='padding:1em; background-color: rgb(0, 154, 205);'>&nbsp;</span> deepskyblue3 


<span style='padding:1em; background-color: rgb(0, 104, 139);'>&nbsp;</span> deepskyblue4 


<span style='padding:1em; background-color: rgb(105, 105, 105);'>&nbsp;</span> dimgray 


<span style='padding:1em; background-color: rgb(105, 105, 105);'>&nbsp;</span> dimgrey 


<span style='padding:1em; background-color: rgb(30, 144, 255);'>&nbsp;</span> dodgerblue 


<span style='padding:1em; background-color: rgb(30, 144, 255);'>&nbsp;</span> dodgerblue1 


<span style='padding:1em; background-color: rgb(28, 134, 238);'>&nbsp;</span> dodgerblue2 


<span style='padding:1em; background-color: rgb(24, 116, 205);'>&nbsp;</span> dodgerblue3 


<span style='padding:1em; background-color: rgb(16, 78, 139);'>&nbsp;</span> dodgerblue4 


<span style='padding:1em; background-color: rgb(178, 34, 34);'>&nbsp;</span> firebrick 


<span style='padding:1em; background-color: rgb(255, 48, 48);'>&nbsp;</span> firebrick1 


<span style='padding:1em; background-color: rgb(238, 44, 44);'>&nbsp;</span> firebrick2 


<span style='padding:1em; background-color: rgb(205, 38, 38);'>&nbsp;</span> firebrick3 


<span style='padding:1em; background-color: rgb(139, 26, 26);'>&nbsp;</span> firebrick4 


<span style='padding:1em; background-color: rgb(255, 250, 240);'>&nbsp;</span> floralwhite 


<span style='padding:1em; background-color: rgb(34, 139, 34);'>&nbsp;</span> forestgreen 


<span style='padding:1em; background-color: rgb(220, 220, 220);'>&nbsp;</span> gainsboro 


<span style='padding:1em; background-color: rgb(248, 248, 255);'>&nbsp;</span> ghostwhite 


<span style='padding:1em; background-color: rgb(255, 215, 0);'>&nbsp;</span> gold 


<span style='padding:1em; background-color: rgb(255, 215, 0);'>&nbsp;</span> gold1 


<span style='padding:1em; background-color: rgb(238, 201, 0);'>&nbsp;</span> gold2 


<span style='padding:1em; background-color: rgb(205, 173, 0);'>&nbsp;</span> gold3 


<span style='padding:1em; background-color: rgb(139, 117, 0);'>&nbsp;</span> gold4 


<span style='padding:1em; background-color: rgb(218, 165, 32);'>&nbsp;</span> goldenrod 


<span style='padding:1em; background-color: rgb(255, 193, 37);'>&nbsp;</span> goldenrod1 


<span style='padding:1em; background-color: rgb(238, 180, 34);'>&nbsp;</span> goldenrod2 


<span style='padding:1em; background-color: rgb(205, 155, 29);'>&nbsp;</span> goldenrod3 


<span style='padding:1em; background-color: rgb(139, 105, 20);'>&nbsp;</span> goldenrod4 


<span style='padding:1em; background-color: rgb(190, 190, 190);'>&nbsp;</span> gray 


<span style='padding:1em; background-color: rgb(0, 0, 0);'>&nbsp;</span> gray0 


<span style='padding:1em; background-color: rgb(3, 3, 3);'>&nbsp;</span> gray1 


<span style='padding:1em; background-color: rgb(5, 5, 5);'>&nbsp;</span> gray2 


<span style='padding:1em; background-color: rgb(8, 8, 8);'>&nbsp;</span> gray3 


<span style='padding:1em; background-color: rgb(10, 10, 10);'>&nbsp;</span> gray4 


<span style='padding:1em; background-color: rgb(13, 13, 13);'>&nbsp;</span> gray5 


<span style='padding:1em; background-color: rgb(15, 15, 15);'>&nbsp;</span> gray6 


<span style='padding:1em; background-color: rgb(18, 18, 18);'>&nbsp;</span> gray7 


<span style='padding:1em; background-color: rgb(20, 20, 20);'>&nbsp;</span> gray8 


<span style='padding:1em; background-color: rgb(23, 23, 23);'>&nbsp;</span> gray9 


<span style='padding:1em; background-color: rgb(26, 26, 26);'>&nbsp;</span> gray10 


<span style='padding:1em; background-color: rgb(28, 28, 28);'>&nbsp;</span> gray11 


<span style='padding:1em; background-color: rgb(31, 31, 31);'>&nbsp;</span> gray12 


<span style='padding:1em; background-color: rgb(33, 33, 33);'>&nbsp;</span> gray13 


<span style='padding:1em; background-color: rgb(36, 36, 36);'>&nbsp;</span> gray14 


<span style='padding:1em; background-color: rgb(38, 38, 38);'>&nbsp;</span> gray15 


<span style='padding:1em; background-color: rgb(41, 41, 41);'>&nbsp;</span> gray16 


<span style='padding:1em; background-color: rgb(43, 43, 43);'>&nbsp;</span> gray17 


<span style='padding:1em; background-color: rgb(46, 46, 46);'>&nbsp;</span> gray18 


<span style='padding:1em; background-color: rgb(48, 48, 48);'>&nbsp;</span> gray19 


<span style='padding:1em; background-color: rgb(51, 51, 51);'>&nbsp;</span> gray20 


<span style='padding:1em; background-color: rgb(54, 54, 54);'>&nbsp;</span> gray21 


<span style='padding:1em; background-color: rgb(56, 56, 56);'>&nbsp;</span> gray22 


<span style='padding:1em; background-color: rgb(59, 59, 59);'>&nbsp;</span> gray23 


<span style='padding:1em; background-color: rgb(61, 61, 61);'>&nbsp;</span> gray24 


<span style='padding:1em; background-color: rgb(64, 64, 64);'>&nbsp;</span> gray25 


<span style='padding:1em; background-color: rgb(66, 66, 66);'>&nbsp;</span> gray26 


<span style='padding:1em; background-color: rgb(69, 69, 69);'>&nbsp;</span> gray27 


<span style='padding:1em; background-color: rgb(71, 71, 71);'>&nbsp;</span> gray28 


<span style='padding:1em; background-color: rgb(74, 74, 74);'>&nbsp;</span> gray29 


<span style='padding:1em; background-color: rgb(77, 77, 77);'>&nbsp;</span> gray30 


<span style='padding:1em; background-color: rgb(79, 79, 79);'>&nbsp;</span> gray31 


<span style='padding:1em; background-color: rgb(82, 82, 82);'>&nbsp;</span> gray32 


<span style='padding:1em; background-color: rgb(84, 84, 84);'>&nbsp;</span> gray33 


<span style='padding:1em; background-color: rgb(87, 87, 87);'>&nbsp;</span> gray34 


<span style='padding:1em; background-color: rgb(89, 89, 89);'>&nbsp;</span> gray35 


<span style='padding:1em; background-color: rgb(92, 92, 92);'>&nbsp;</span> gray36 


<span style='padding:1em; background-color: rgb(94, 94, 94);'>&nbsp;</span> gray37 


<span style='padding:1em; background-color: rgb(97, 97, 97);'>&nbsp;</span> gray38 


<span style='padding:1em; background-color: rgb(99, 99, 99);'>&nbsp;</span> gray39 


<span style='padding:1em; background-color: rgb(102, 102, 102);'>&nbsp;</span> gray40 


<span style='padding:1em; background-color: rgb(105, 105, 105);'>&nbsp;</span> gray41 


<span style='padding:1em; background-color: rgb(107, 107, 107);'>&nbsp;</span> gray42 


<span style='padding:1em; background-color: rgb(110, 110, 110);'>&nbsp;</span> gray43 


<span style='padding:1em; background-color: rgb(112, 112, 112);'>&nbsp;</span> gray44 


<span style='padding:1em; background-color: rgb(115, 115, 115);'>&nbsp;</span> gray45 


<span style='padding:1em; background-color: rgb(117, 117, 117);'>&nbsp;</span> gray46 


<span style='padding:1em; background-color: rgb(120, 120, 120);'>&nbsp;</span> gray47 


<span style='padding:1em; background-color: rgb(122, 122, 122);'>&nbsp;</span> gray48 


<span style='padding:1em; background-color: rgb(125, 125, 125);'>&nbsp;</span> gray49 


<span style='padding:1em; background-color: rgb(127, 127, 127);'>&nbsp;</span> gray50 


<span style='padding:1em; background-color: rgb(130, 130, 130);'>&nbsp;</span> gray51 


<span style='padding:1em; background-color: rgb(133, 133, 133);'>&nbsp;</span> gray52 


<span style='padding:1em; background-color: rgb(135, 135, 135);'>&nbsp;</span> gray53 


<span style='padding:1em; background-color: rgb(138, 138, 138);'>&nbsp;</span> gray54 


<span style='padding:1em; background-color: rgb(140, 140, 140);'>&nbsp;</span> gray55 


<span style='padding:1em; background-color: rgb(143, 143, 143);'>&nbsp;</span> gray56 


<span style='padding:1em; background-color: rgb(145, 145, 145);'>&nbsp;</span> gray57 


<span style='padding:1em; background-color: rgb(148, 148, 148);'>&nbsp;</span> gray58 


<span style='padding:1em; background-color: rgb(150, 150, 150);'>&nbsp;</span> gray59 


<span style='padding:1em; background-color: rgb(153, 153, 153);'>&nbsp;</span> gray60 


<span style='padding:1em; background-color: rgb(156, 156, 156);'>&nbsp;</span> gray61 


<span style='padding:1em; background-color: rgb(158, 158, 158);'>&nbsp;</span> gray62 


<span style='padding:1em; background-color: rgb(161, 161, 161);'>&nbsp;</span> gray63 


<span style='padding:1em; background-color: rgb(163, 163, 163);'>&nbsp;</span> gray64 


<span style='padding:1em; background-color: rgb(166, 166, 166);'>&nbsp;</span> gray65 


<span style='padding:1em; background-color: rgb(168, 168, 168);'>&nbsp;</span> gray66 


<span style='padding:1em; background-color: rgb(171, 171, 171);'>&nbsp;</span> gray67 


<span style='padding:1em; background-color: rgb(173, 173, 173);'>&nbsp;</span> gray68 


<span style='padding:1em; background-color: rgb(176, 176, 176);'>&nbsp;</span> gray69 


<span style='padding:1em; background-color: rgb(179, 179, 179);'>&nbsp;</span> gray70 


<span style='padding:1em; background-color: rgb(181, 181, 181);'>&nbsp;</span> gray71 


<span style='padding:1em; background-color: rgb(184, 184, 184);'>&nbsp;</span> gray72 


<span style='padding:1em; background-color: rgb(186, 186, 186);'>&nbsp;</span> gray73 


<span style='padding:1em; background-color: rgb(189, 189, 189);'>&nbsp;</span> gray74 


<span style='padding:1em; background-color: rgb(191, 191, 191);'>&nbsp;</span> gray75 


<span style='padding:1em; background-color: rgb(194, 194, 194);'>&nbsp;</span> gray76 


<span style='padding:1em; background-color: rgb(196, 196, 196);'>&nbsp;</span> gray77 


<span style='padding:1em; background-color: rgb(199, 199, 199);'>&nbsp;</span> gray78 


<span style='padding:1em; background-color: rgb(201, 201, 201);'>&nbsp;</span> gray79 


<span style='padding:1em; background-color: rgb(204, 204, 204);'>&nbsp;</span> gray80 


<span style='padding:1em; background-color: rgb(207, 207, 207);'>&nbsp;</span> gray81 


<span style='padding:1em; background-color: rgb(209, 209, 209);'>&nbsp;</span> gray82 


<span style='padding:1em; background-color: rgb(212, 212, 212);'>&nbsp;</span> gray83 


<span style='padding:1em; background-color: rgb(214, 214, 214);'>&nbsp;</span> gray84 


<span style='padding:1em; background-color: rgb(217, 217, 217);'>&nbsp;</span> gray85 


<span style='padding:1em; background-color: rgb(219, 219, 219);'>&nbsp;</span> gray86 


<span style='padding:1em; background-color: rgb(222, 222, 222);'>&nbsp;</span> gray87 


<span style='padding:1em; background-color: rgb(224, 224, 224);'>&nbsp;</span> gray88 


<span style='padding:1em; background-color: rgb(227, 227, 227);'>&nbsp;</span> gray89 


<span style='padding:1em; background-color: rgb(229, 229, 229);'>&nbsp;</span> gray90 


<span style='padding:1em; background-color: rgb(232, 232, 232);'>&nbsp;</span> gray91 


<span style='padding:1em; background-color: rgb(235, 235, 235);'>&nbsp;</span> gray92 


<span style='padding:1em; background-color: rgb(237, 237, 237);'>&nbsp;</span> gray93 


<span style='padding:1em; background-color: rgb(240, 240, 240);'>&nbsp;</span> gray94 


<span style='padding:1em; background-color: rgb(242, 242, 242);'>&nbsp;</span> gray95 


<span style='padding:1em; background-color: rgb(245, 245, 245);'>&nbsp;</span> gray96 


<span style='padding:1em; background-color: rgb(247, 247, 247);'>&nbsp;</span> gray97 


<span style='padding:1em; background-color: rgb(250, 250, 250);'>&nbsp;</span> gray98 


<span style='padding:1em; background-color: rgb(252, 252, 252);'>&nbsp;</span> gray99 


<span style='padding:1em; background-color: rgb(255, 255, 255);'>&nbsp;</span> gray100 


<span style='padding:1em; background-color: rgb(0, 255, 0);'>&nbsp;</span> green 


<span style='padding:1em; background-color: rgb(0, 255, 0);'>&nbsp;</span> green1 


<span style='padding:1em; background-color: rgb(0, 238, 0);'>&nbsp;</span> green2 


<span style='padding:1em; background-color: rgb(0, 205, 0);'>&nbsp;</span> green3 


<span style='padding:1em; background-color: rgb(0, 139, 0);'>&nbsp;</span> green4 


<span style='padding:1em; background-color: rgb(173, 255, 47);'>&nbsp;</span> greenyellow 


<span style='padding:1em; background-color: rgb(190, 190, 190);'>&nbsp;</span> grey 


<span style='padding:1em; background-color: rgb(0, 0, 0);'>&nbsp;</span> grey0 


<span style='padding:1em; background-color: rgb(3, 3, 3);'>&nbsp;</span> grey1 


<span style='padding:1em; background-color: rgb(5, 5, 5);'>&nbsp;</span> grey2 


<span style='padding:1em; background-color: rgb(8, 8, 8);'>&nbsp;</span> grey3 


<span style='padding:1em; background-color: rgb(10, 10, 10);'>&nbsp;</span> grey4 


<span style='padding:1em; background-color: rgb(13, 13, 13);'>&nbsp;</span> grey5 


<span style='padding:1em; background-color: rgb(15, 15, 15);'>&nbsp;</span> grey6 


<span style='padding:1em; background-color: rgb(18, 18, 18);'>&nbsp;</span> grey7 


<span style='padding:1em; background-color: rgb(20, 20, 20);'>&nbsp;</span> grey8 


<span style='padding:1em; background-color: rgb(23, 23, 23);'>&nbsp;</span> grey9 


<span style='padding:1em; background-color: rgb(26, 26, 26);'>&nbsp;</span> grey10 


<span style='padding:1em; background-color: rgb(28, 28, 28);'>&nbsp;</span> grey11 


<span style='padding:1em; background-color: rgb(31, 31, 31);'>&nbsp;</span> grey12 


<span style='padding:1em; background-color: rgb(33, 33, 33);'>&nbsp;</span> grey13 


<span style='padding:1em; background-color: rgb(36, 36, 36);'>&nbsp;</span> grey14 


<span style='padding:1em; background-color: rgb(38, 38, 38);'>&nbsp;</span> grey15 


<span style='padding:1em; background-color: rgb(41, 41, 41);'>&nbsp;</span> grey16 


<span style='padding:1em; background-color: rgb(43, 43, 43);'>&nbsp;</span> grey17 


<span style='padding:1em; background-color: rgb(46, 46, 46);'>&nbsp;</span> grey18 


<span style='padding:1em; background-color: rgb(48, 48, 48);'>&nbsp;</span> grey19 


<span style='padding:1em; background-color: rgb(51, 51, 51);'>&nbsp;</span> grey20 


<span style='padding:1em; background-color: rgb(54, 54, 54);'>&nbsp;</span> grey21 


<span style='padding:1em; background-color: rgb(56, 56, 56);'>&nbsp;</span> grey22 


<span style='padding:1em; background-color: rgb(59, 59, 59);'>&nbsp;</span> grey23 


<span style='padding:1em; background-color: rgb(61, 61, 61);'>&nbsp;</span> grey24 


<span style='padding:1em; background-color: rgb(64, 64, 64);'>&nbsp;</span> grey25 


<span style='padding:1em; background-color: rgb(66, 66, 66);'>&nbsp;</span> grey26 


<span style='padding:1em; background-color: rgb(69, 69, 69);'>&nbsp;</span> grey27 


<span style='padding:1em; background-color: rgb(71, 71, 71);'>&nbsp;</span> grey28 


<span style='padding:1em; background-color: rgb(74, 74, 74);'>&nbsp;</span> grey29 


<span style='padding:1em; background-color: rgb(77, 77, 77);'>&nbsp;</span> grey30 


<span style='padding:1em; background-color: rgb(79, 79, 79);'>&nbsp;</span> grey31 


<span style='padding:1em; background-color: rgb(82, 82, 82);'>&nbsp;</span> grey32 


<span style='padding:1em; background-color: rgb(84, 84, 84);'>&nbsp;</span> grey33 


<span style='padding:1em; background-color: rgb(87, 87, 87);'>&nbsp;</span> grey34 


<span style='padding:1em; background-color: rgb(89, 89, 89);'>&nbsp;</span> grey35 


<span style='padding:1em; background-color: rgb(92, 92, 92);'>&nbsp;</span> grey36 


<span style='padding:1em; background-color: rgb(94, 94, 94);'>&nbsp;</span> grey37 


<span style='padding:1em; background-color: rgb(97, 97, 97);'>&nbsp;</span> grey38 


<span style='padding:1em; background-color: rgb(99, 99, 99);'>&nbsp;</span> grey39 


<span style='padding:1em; background-color: rgb(102, 102, 102);'>&nbsp;</span> grey40 


<span style='padding:1em; background-color: rgb(105, 105, 105);'>&nbsp;</span> grey41 


<span style='padding:1em; background-color: rgb(107, 107, 107);'>&nbsp;</span> grey42 


<span style='padding:1em; background-color: rgb(110, 110, 110);'>&nbsp;</span> grey43 


<span style='padding:1em; background-color: rgb(112, 112, 112);'>&nbsp;</span> grey44 


<span style='padding:1em; background-color: rgb(115, 115, 115);'>&nbsp;</span> grey45 


<span style='padding:1em; background-color: rgb(117, 117, 117);'>&nbsp;</span> grey46 


<span style='padding:1em; background-color: rgb(120, 120, 120);'>&nbsp;</span> grey47 


<span style='padding:1em; background-color: rgb(122, 122, 122);'>&nbsp;</span> grey48 


<span style='padding:1em; background-color: rgb(125, 125, 125);'>&nbsp;</span> grey49 


<span style='padding:1em; background-color: rgb(127, 127, 127);'>&nbsp;</span> grey50 


<span style='padding:1em; background-color: rgb(130, 130, 130);'>&nbsp;</span> grey51 


<span style='padding:1em; background-color: rgb(133, 133, 133);'>&nbsp;</span> grey52 


<span style='padding:1em; background-color: rgb(135, 135, 135);'>&nbsp;</span> grey53 


<span style='padding:1em; background-color: rgb(138, 138, 138);'>&nbsp;</span> grey54 


<span style='padding:1em; background-color: rgb(140, 140, 140);'>&nbsp;</span> grey55 


<span style='padding:1em; background-color: rgb(143, 143, 143);'>&nbsp;</span> grey56 


<span style='padding:1em; background-color: rgb(145, 145, 145);'>&nbsp;</span> grey57 


<span style='padding:1em; background-color: rgb(148, 148, 148);'>&nbsp;</span> grey58 


<span style='padding:1em; background-color: rgb(150, 150, 150);'>&nbsp;</span> grey59 


<span style='padding:1em; background-color: rgb(153, 153, 153);'>&nbsp;</span> grey60 


<span style='padding:1em; background-color: rgb(156, 156, 156);'>&nbsp;</span> grey61 


<span style='padding:1em; background-color: rgb(158, 158, 158);'>&nbsp;</span> grey62 


<span style='padding:1em; background-color: rgb(161, 161, 161);'>&nbsp;</span> grey63 


<span style='padding:1em; background-color: rgb(163, 163, 163);'>&nbsp;</span> grey64 


<span style='padding:1em; background-color: rgb(166, 166, 166);'>&nbsp;</span> grey65 


<span style='padding:1em; background-color: rgb(168, 168, 168);'>&nbsp;</span> grey66 


<span style='padding:1em; background-color: rgb(171, 171, 171);'>&nbsp;</span> grey67 


<span style='padding:1em; background-color: rgb(173, 173, 173);'>&nbsp;</span> grey68 


<span style='padding:1em; background-color: rgb(176, 176, 176);'>&nbsp;</span> grey69 


<span style='padding:1em; background-color: rgb(179, 179, 179);'>&nbsp;</span> grey70 


<span style='padding:1em; background-color: rgb(181, 181, 181);'>&nbsp;</span> grey71 


<span style='padding:1em; background-color: rgb(184, 184, 184);'>&nbsp;</span> grey72 


<span style='padding:1em; background-color: rgb(186, 186, 186);'>&nbsp;</span> grey73 


<span style='padding:1em; background-color: rgb(189, 189, 189);'>&nbsp;</span> grey74 


<span style='padding:1em; background-color: rgb(191, 191, 191);'>&nbsp;</span> grey75 


<span style='padding:1em; background-color: rgb(194, 194, 194);'>&nbsp;</span> grey76 


<span style='padding:1em; background-color: rgb(196, 196, 196);'>&nbsp;</span> grey77 


<span style='padding:1em; background-color: rgb(199, 199, 199);'>&nbsp;</span> grey78 


<span style='padding:1em; background-color: rgb(201, 201, 201);'>&nbsp;</span> grey79 


<span style='padding:1em; background-color: rgb(204, 204, 204);'>&nbsp;</span> grey80 


<span style='padding:1em; background-color: rgb(207, 207, 207);'>&nbsp;</span> grey81 


<span style='padding:1em; background-color: rgb(209, 209, 209);'>&nbsp;</span> grey82 


<span style='padding:1em; background-color: rgb(212, 212, 212);'>&nbsp;</span> grey83 


<span style='padding:1em; background-color: rgb(214, 214, 214);'>&nbsp;</span> grey84 


<span style='padding:1em; background-color: rgb(217, 217, 217);'>&nbsp;</span> grey85 


<span style='padding:1em; background-color: rgb(219, 219, 219);'>&nbsp;</span> grey86 


<span style='padding:1em; background-color: rgb(222, 222, 222);'>&nbsp;</span> grey87 


<span style='padding:1em; background-color: rgb(224, 224, 224);'>&nbsp;</span> grey88 


<span style='padding:1em; background-color: rgb(227, 227, 227);'>&nbsp;</span> grey89 


<span style='padding:1em; background-color: rgb(229, 229, 229);'>&nbsp;</span> grey90 


<span style='padding:1em; background-color: rgb(232, 232, 232);'>&nbsp;</span> grey91 


<span style='padding:1em; background-color: rgb(235, 235, 235);'>&nbsp;</span> grey92 


<span style='padding:1em; background-color: rgb(237, 237, 237);'>&nbsp;</span> grey93 


<span style='padding:1em; background-color: rgb(240, 240, 240);'>&nbsp;</span> grey94 


<span style='padding:1em; background-color: rgb(242, 242, 242);'>&nbsp;</span> grey95 


<span style='padding:1em; background-color: rgb(245, 245, 245);'>&nbsp;</span> grey96 


<span style='padding:1em; background-color: rgb(247, 247, 247);'>&nbsp;</span> grey97 


<span style='padding:1em; background-color: rgb(250, 250, 250);'>&nbsp;</span> grey98 


<span style='padding:1em; background-color: rgb(252, 252, 252);'>&nbsp;</span> grey99 


<span style='padding:1em; background-color: rgb(255, 255, 255);'>&nbsp;</span> grey100 


<span style='padding:1em; background-color: rgb(240, 255, 240);'>&nbsp;</span> honeydew 


<span style='padding:1em; background-color: rgb(240, 255, 240);'>&nbsp;</span> honeydew1 


<span style='padding:1em; background-color: rgb(224, 238, 224);'>&nbsp;</span> honeydew2 


<span style='padding:1em; background-color: rgb(193, 205, 193);'>&nbsp;</span> honeydew3 


<span style='padding:1em; background-color: rgb(131, 139, 131);'>&nbsp;</span> honeydew4 


<span style='padding:1em; background-color: rgb(255, 105, 180);'>&nbsp;</span> hotpink 


<span style='padding:1em; background-color: rgb(255, 110, 180);'>&nbsp;</span> hotpink1 


<span style='padding:1em; background-color: rgb(238, 106, 167);'>&nbsp;</span> hotpink2 


<span style='padding:1em; background-color: rgb(205, 96, 144);'>&nbsp;</span> hotpink3 


<span style='padding:1em; background-color: rgb(139, 58, 98);'>&nbsp;</span> hotpink4 


<span style='padding:1em; background-color: rgb(205, 92, 92);'>&nbsp;</span> indianred 


<span style='padding:1em; background-color: rgb(255, 106, 106);'>&nbsp;</span> indianred1 


<span style='padding:1em; background-color: rgb(238, 99, 99);'>&nbsp;</span> indianred2 


<span style='padding:1em; background-color: rgb(205, 85, 85);'>&nbsp;</span> indianred3 


<span style='padding:1em; background-color: rgb(139, 58, 58);'>&nbsp;</span> indianred4 


<span style='padding:1em; background-color: rgb(255, 255, 240);'>&nbsp;</span> ivory 


<span style='padding:1em; background-color: rgb(255, 255, 240);'>&nbsp;</span> ivory1 


<span style='padding:1em; background-color: rgb(238, 238, 224);'>&nbsp;</span> ivory2 


<span style='padding:1em; background-color: rgb(205, 205, 193);'>&nbsp;</span> ivory3 


<span style='padding:1em; background-color: rgb(139, 139, 131);'>&nbsp;</span> ivory4 


<span style='padding:1em; background-color: rgb(240, 230, 140);'>&nbsp;</span> khaki 


<span style='padding:1em; background-color: rgb(255, 246, 143);'>&nbsp;</span> khaki1 


<span style='padding:1em; background-color: rgb(238, 230, 133);'>&nbsp;</span> khaki2 


<span style='padding:1em; background-color: rgb(205, 198, 115);'>&nbsp;</span> khaki3 


<span style='padding:1em; background-color: rgb(139, 134, 78);'>&nbsp;</span> khaki4 


<span style='padding:1em; background-color: rgb(230, 230, 250);'>&nbsp;</span> lavender 


<span style='padding:1em; background-color: rgb(255, 240, 245);'>&nbsp;</span> lavenderblush 


<span style='padding:1em; background-color: rgb(255, 240, 245);'>&nbsp;</span> lavenderblush1 


<span style='padding:1em; background-color: rgb(238, 224, 229);'>&nbsp;</span> lavenderblush2 


<span style='padding:1em; background-color: rgb(205, 193, 197);'>&nbsp;</span> lavenderblush3 


<span style='padding:1em; background-color: rgb(139, 131, 134);'>&nbsp;</span> lavenderblush4 


<span style='padding:1em; background-color: rgb(124, 252, 0);'>&nbsp;</span> lawngreen 


<span style='padding:1em; background-color: rgb(255, 250, 205);'>&nbsp;</span> lemonchiffon 


<span style='padding:1em; background-color: rgb(255, 250, 205);'>&nbsp;</span> lemonchiffon1 


<span style='padding:1em; background-color: rgb(238, 233, 191);'>&nbsp;</span> lemonchiffon2 


<span style='padding:1em; background-color: rgb(205, 201, 165);'>&nbsp;</span> lemonchiffon3 


<span style='padding:1em; background-color: rgb(139, 137, 112);'>&nbsp;</span> lemonchiffon4 


<span style='padding:1em; background-color: rgb(173, 216, 230);'>&nbsp;</span> lightblue 


<span style='padding:1em; background-color: rgb(191, 239, 255);'>&nbsp;</span> lightblue1 


<span style='padding:1em; background-color: rgb(178, 223, 238);'>&nbsp;</span> lightblue2 


<span style='padding:1em; background-color: rgb(154, 192, 205);'>&nbsp;</span> lightblue3 


<span style='padding:1em; background-color: rgb(104, 131, 139);'>&nbsp;</span> lightblue4 


<span style='padding:1em; background-color: rgb(240, 128, 128);'>&nbsp;</span> lightcoral 


<span style='padding:1em; background-color: rgb(224, 255, 255);'>&nbsp;</span> lightcyan 


<span style='padding:1em; background-color: rgb(224, 255, 255);'>&nbsp;</span> lightcyan1 


<span style='padding:1em; background-color: rgb(209, 238, 238);'>&nbsp;</span> lightcyan2 


<span style='padding:1em; background-color: rgb(180, 205, 205);'>&nbsp;</span> lightcyan3 


<span style='padding:1em; background-color: rgb(122, 139, 139);'>&nbsp;</span> lightcyan4 


<span style='padding:1em; background-color: rgb(238, 221, 130);'>&nbsp;</span> lightgoldenrod 


<span style='padding:1em; background-color: rgb(255, 236, 139);'>&nbsp;</span> lightgoldenrod1 


<span style='padding:1em; background-color: rgb(238, 220, 130);'>&nbsp;</span> lightgoldenrod2 


<span style='padding:1em; background-color: rgb(205, 190, 112);'>&nbsp;</span> lightgoldenrod3 


<span style='padding:1em; background-color: rgb(139, 129, 76);'>&nbsp;</span> lightgoldenrod4 


<span style='padding:1em; background-color: rgb(250, 250, 210);'>&nbsp;</span> lightgoldenrodyellow 


<span style='padding:1em; background-color: rgb(211, 211, 211);'>&nbsp;</span> lightgray 


<span style='padding:1em; background-color: rgb(144, 238, 144);'>&nbsp;</span> lightgreen 


<span style='padding:1em; background-color: rgb(211, 211, 211);'>&nbsp;</span> lightgrey 


<span style='padding:1em; background-color: rgb(255, 182, 193);'>&nbsp;</span> lightpink 


<span style='padding:1em; background-color: rgb(255, 174, 185);'>&nbsp;</span> lightpink1 


<span style='padding:1em; background-color: rgb(238, 162, 173);'>&nbsp;</span> lightpink2 


<span style='padding:1em; background-color: rgb(205, 140, 149);'>&nbsp;</span> lightpink3 


<span style='padding:1em; background-color: rgb(139, 95, 101);'>&nbsp;</span> lightpink4 


<span style='padding:1em; background-color: rgb(255, 160, 122);'>&nbsp;</span> lightsalmon 


<span style='padding:1em; background-color: rgb(255, 160, 122);'>&nbsp;</span> lightsalmon1 


<span style='padding:1em; background-color: rgb(238, 149, 114);'>&nbsp;</span> lightsalmon2 


<span style='padding:1em; background-color: rgb(205, 129, 98);'>&nbsp;</span> lightsalmon3 


<span style='padding:1em; background-color: rgb(139, 87, 66);'>&nbsp;</span> lightsalmon4 


<span style='padding:1em; background-color: rgb(32, 178, 170);'>&nbsp;</span> lightseagreen 


<span style='padding:1em; background-color: rgb(135, 206, 250);'>&nbsp;</span> lightskyblue 


<span style='padding:1em; background-color: rgb(176, 226, 255);'>&nbsp;</span> lightskyblue1 


<span style='padding:1em; background-color: rgb(164, 211, 238);'>&nbsp;</span> lightskyblue2 


<span style='padding:1em; background-color: rgb(141, 182, 205);'>&nbsp;</span> lightskyblue3 


<span style='padding:1em; background-color: rgb(96, 123, 139);'>&nbsp;</span> lightskyblue4 


<span style='padding:1em; background-color: rgb(132, 112, 255);'>&nbsp;</span> lightslateblue 


<span style='padding:1em; background-color: rgb(119, 136, 153);'>&nbsp;</span> lightslategray 


<span style='padding:1em; background-color: rgb(119, 136, 153);'>&nbsp;</span> lightslategrey 


<span style='padding:1em; background-color: rgb(176, 196, 222);'>&nbsp;</span> lightsteelblue 


<span style='padding:1em; background-color: rgb(202, 225, 255);'>&nbsp;</span> lightsteelblue1 


<span style='padding:1em; background-color: rgb(188, 210, 238);'>&nbsp;</span> lightsteelblue2 


<span style='padding:1em; background-color: rgb(162, 181, 205);'>&nbsp;</span> lightsteelblue3 


<span style='padding:1em; background-color: rgb(110, 123, 139);'>&nbsp;</span> lightsteelblue4 


<span style='padding:1em; background-color: rgb(255, 255, 224);'>&nbsp;</span> lightyellow 


<span style='padding:1em; background-color: rgb(255, 255, 224);'>&nbsp;</span> lightyellow1 


<span style='padding:1em; background-color: rgb(238, 238, 209);'>&nbsp;</span> lightyellow2 


<span style='padding:1em; background-color: rgb(205, 205, 180);'>&nbsp;</span> lightyellow3 


<span style='padding:1em; background-color: rgb(139, 139, 122);'>&nbsp;</span> lightyellow4 


<span style='padding:1em; background-color: rgb(50, 205, 50);'>&nbsp;</span> limegreen 


<span style='padding:1em; background-color: rgb(250, 240, 230);'>&nbsp;</span> linen 


<span style='padding:1em; background-color: rgb(255, 0, 255);'>&nbsp;</span> magenta 


<span style='padding:1em; background-color: rgb(255, 0, 255);'>&nbsp;</span> magenta1 


<span style='padding:1em; background-color: rgb(238, 0, 238);'>&nbsp;</span> magenta2 


<span style='padding:1em; background-color: rgb(205, 0, 205);'>&nbsp;</span> magenta3 


<span style='padding:1em; background-color: rgb(139, 0, 139);'>&nbsp;</span> magenta4 


<span style='padding:1em; background-color: rgb(176, 48, 96);'>&nbsp;</span> maroon 


<span style='padding:1em; background-color: rgb(255, 52, 179);'>&nbsp;</span> maroon1 


<span style='padding:1em; background-color: rgb(238, 48, 167);'>&nbsp;</span> maroon2 


<span style='padding:1em; background-color: rgb(205, 41, 144);'>&nbsp;</span> maroon3 


<span style='padding:1em; background-color: rgb(139, 28, 98);'>&nbsp;</span> maroon4 


<span style='padding:1em; background-color: rgb(102, 205, 170);'>&nbsp;</span> mediumaquamarine 


<span style='padding:1em; background-color: rgb(0, 0, 205);'>&nbsp;</span> mediumblue 


<span style='padding:1em; background-color: rgb(186, 85, 211);'>&nbsp;</span> mediumorchid 


<span style='padding:1em; background-color: rgb(224, 102, 255);'>&nbsp;</span> mediumorchid1 


<span style='padding:1em; background-color: rgb(209, 95, 238);'>&nbsp;</span> mediumorchid2 


<span style='padding:1em; background-color: rgb(180, 82, 205);'>&nbsp;</span> mediumorchid3 


<span style='padding:1em; background-color: rgb(122, 55, 139);'>&nbsp;</span> mediumorchid4 


<span style='padding:1em; background-color: rgb(147, 112, 219);'>&nbsp;</span> mediumpurple 


<span style='padding:1em; background-color: rgb(171, 130, 255);'>&nbsp;</span> mediumpurple1 


<span style='padding:1em; background-color: rgb(159, 121, 238);'>&nbsp;</span> mediumpurple2 


<span style='padding:1em; background-color: rgb(137, 104, 205);'>&nbsp;</span> mediumpurple3 


<span style='padding:1em; background-color: rgb(93, 71, 139);'>&nbsp;</span> mediumpurple4 


<span style='padding:1em; background-color: rgb(60, 179, 113);'>&nbsp;</span> mediumseagreen 


<span style='padding:1em; background-color: rgb(123, 104, 238);'>&nbsp;</span> mediumslateblue 


<span style='padding:1em; background-color: rgb(0, 250, 154);'>&nbsp;</span> mediumspringgreen 


<span style='padding:1em; background-color: rgb(72, 209, 204);'>&nbsp;</span> mediumturquoise 


<span style='padding:1em; background-color: rgb(199, 21, 133);'>&nbsp;</span> mediumvioletred 


<span style='padding:1em; background-color: rgb(25, 25, 112);'>&nbsp;</span> midnightblue 


<span style='padding:1em; background-color: rgb(245, 255, 250);'>&nbsp;</span> mintcream 


<span style='padding:1em; background-color: rgb(255, 228, 225);'>&nbsp;</span> mistyrose 


<span style='padding:1em; background-color: rgb(255, 228, 225);'>&nbsp;</span> mistyrose1 


<span style='padding:1em; background-color: rgb(238, 213, 210);'>&nbsp;</span> mistyrose2 


<span style='padding:1em; background-color: rgb(205, 183, 181);'>&nbsp;</span> mistyrose3 


<span style='padding:1em; background-color: rgb(139, 125, 123);'>&nbsp;</span> mistyrose4 


<span style='padding:1em; background-color: rgb(255, 228, 181);'>&nbsp;</span> moccasin 


<span style='padding:1em; background-color: rgb(255, 222, 173);'>&nbsp;</span> navajowhite 


<span style='padding:1em; background-color: rgb(255, 222, 173);'>&nbsp;</span> navajowhite1 


<span style='padding:1em; background-color: rgb(238, 207, 161);'>&nbsp;</span> navajowhite2 


<span style='padding:1em; background-color: rgb(205, 179, 139);'>&nbsp;</span> navajowhite3 


<span style='padding:1em; background-color: rgb(139, 121, 94);'>&nbsp;</span> navajowhite4 


<span style='padding:1em; background-color: rgb(0, 0, 128);'>&nbsp;</span> navy 


<span style='padding:1em; background-color: rgb(0, 0, 128);'>&nbsp;</span> navyblue 


<span style='padding:1em; background-color: rgb(253, 245, 230);'>&nbsp;</span> oldlace 


<span style='padding:1em; background-color: rgb(107, 142, 35);'>&nbsp;</span> olivedrab 


<span style='padding:1em; background-color: rgb(192, 255, 62);'>&nbsp;</span> olivedrab1 


<span style='padding:1em; background-color: rgb(179, 238, 58);'>&nbsp;</span> olivedrab2 


<span style='padding:1em; background-color: rgb(154, 205, 50);'>&nbsp;</span> olivedrab3 


<span style='padding:1em; background-color: rgb(105, 139, 34);'>&nbsp;</span> olivedrab4 


<span style='padding:1em; background-color: rgb(255, 165, 0);'>&nbsp;</span> orange 


<span style='padding:1em; background-color: rgb(255, 165, 0);'>&nbsp;</span> orange1 


<span style='padding:1em; background-color: rgb(238, 154, 0);'>&nbsp;</span> orange2 


<span style='padding:1em; background-color: rgb(205, 133, 0);'>&nbsp;</span> orange3 


<span style='padding:1em; background-color: rgb(139, 90, 0);'>&nbsp;</span> orange4 


<span style='padding:1em; background-color: rgb(255, 69, 0);'>&nbsp;</span> orangered 


<span style='padding:1em; background-color: rgb(255, 69, 0);'>&nbsp;</span> orangered1 


<span style='padding:1em; background-color: rgb(238, 64, 0);'>&nbsp;</span> orangered2 


<span style='padding:1em; background-color: rgb(205, 55, 0);'>&nbsp;</span> orangered3 


<span style='padding:1em; background-color: rgb(139, 37, 0);'>&nbsp;</span> orangered4 


<span style='padding:1em; background-color: rgb(218, 112, 214);'>&nbsp;</span> orchid 


<span style='padding:1em; background-color: rgb(255, 131, 250);'>&nbsp;</span> orchid1 


<span style='padding:1em; background-color: rgb(238, 122, 233);'>&nbsp;</span> orchid2 


<span style='padding:1em; background-color: rgb(205, 105, 201);'>&nbsp;</span> orchid3 


<span style='padding:1em; background-color: rgb(139, 71, 137);'>&nbsp;</span> orchid4 


<span style='padding:1em; background-color: rgb(238, 232, 170);'>&nbsp;</span> palegoldenrod 


<span style='padding:1em; background-color: rgb(152, 251, 152);'>&nbsp;</span> palegreen 


<span style='padding:1em; background-color: rgb(154, 255, 154);'>&nbsp;</span> palegreen1 


<span style='padding:1em; background-color: rgb(144, 238, 144);'>&nbsp;</span> palegreen2 


<span style='padding:1em; background-color: rgb(124, 205, 124);'>&nbsp;</span> palegreen3 


<span style='padding:1em; background-color: rgb(84, 139, 84);'>&nbsp;</span> palegreen4 


<span style='padding:1em; background-color: rgb(175, 238, 238);'>&nbsp;</span> paleturquoise 


<span style='padding:1em; background-color: rgb(187, 255, 255);'>&nbsp;</span> paleturquoise1 


<span style='padding:1em; background-color: rgb(174, 238, 238);'>&nbsp;</span> paleturquoise2 


<span style='padding:1em; background-color: rgb(150, 205, 205);'>&nbsp;</span> paleturquoise3 


<span style='padding:1em; background-color: rgb(102, 139, 139);'>&nbsp;</span> paleturquoise4 


<span style='padding:1em; background-color: rgb(219, 112, 147);'>&nbsp;</span> palevioletred 


<span style='padding:1em; background-color: rgb(255, 130, 171);'>&nbsp;</span> palevioletred1 


<span style='padding:1em; background-color: rgb(238, 121, 159);'>&nbsp;</span> palevioletred2 


<span style='padding:1em; background-color: rgb(205, 104, 137);'>&nbsp;</span> palevioletred3 


<span style='padding:1em; background-color: rgb(139, 71, 93);'>&nbsp;</span> palevioletred4 


<span style='padding:1em; background-color: rgb(255, 239, 213);'>&nbsp;</span> papayawhip 


<span style='padding:1em; background-color: rgb(255, 218, 185);'>&nbsp;</span> peachpuff 


<span style='padding:1em; background-color: rgb(255, 218, 185);'>&nbsp;</span> peachpuff1 


<span style='padding:1em; background-color: rgb(238, 203, 173);'>&nbsp;</span> peachpuff2 


<span style='padding:1em; background-color: rgb(205, 175, 149);'>&nbsp;</span> peachpuff3 


<span style='padding:1em; background-color: rgb(139, 119, 101);'>&nbsp;</span> peachpuff4 


<span style='padding:1em; background-color: rgb(205, 133, 63);'>&nbsp;</span> peru 


<span style='padding:1em; background-color: rgb(255, 192, 203);'>&nbsp;</span> pink 


<span style='padding:1em; background-color: rgb(255, 181, 197);'>&nbsp;</span> pink1 


<span style='padding:1em; background-color: rgb(238, 169, 184);'>&nbsp;</span> pink2 


<span style='padding:1em; background-color: rgb(205, 145, 158);'>&nbsp;</span> pink3 


<span style='padding:1em; background-color: rgb(139, 99, 108);'>&nbsp;</span> pink4 


<span style='padding:1em; background-color: rgb(221, 160, 221);'>&nbsp;</span> plum 


<span style='padding:1em; background-color: rgb(255, 187, 255);'>&nbsp;</span> plum1 


<span style='padding:1em; background-color: rgb(238, 174, 238);'>&nbsp;</span> plum2 


<span style='padding:1em; background-color: rgb(205, 150, 205);'>&nbsp;</span> plum3 


<span style='padding:1em; background-color: rgb(139, 102, 139);'>&nbsp;</span> plum4 


<span style='padding:1em; background-color: rgb(176, 224, 230);'>&nbsp;</span> powderblue 


<span style='padding:1em; background-color: rgb(160, 32, 240);'>&nbsp;</span> purple 


<span style='padding:1em; background-color: rgb(155, 48, 255);'>&nbsp;</span> purple1 


<span style='padding:1em; background-color: rgb(145, 44, 238);'>&nbsp;</span> purple2 


<span style='padding:1em; background-color: rgb(125, 38, 205);'>&nbsp;</span> purple3 


<span style='padding:1em; background-color: rgb(85, 26, 139);'>&nbsp;</span> purple4 


<span style='padding:1em; background-color: rgb(255, 0, 0);'>&nbsp;</span> red 


<span style='padding:1em; background-color: rgb(255, 0, 0);'>&nbsp;</span> red1 


<span style='padding:1em; background-color: rgb(238, 0, 0);'>&nbsp;</span> red2 


<span style='padding:1em; background-color: rgb(205, 0, 0);'>&nbsp;</span> red3 


<span style='padding:1em; background-color: rgb(139, 0, 0);'>&nbsp;</span> red4 


<span style='padding:1em; background-color: rgb(188, 143, 143);'>&nbsp;</span> rosybrown 


<span style='padding:1em; background-color: rgb(255, 193, 193);'>&nbsp;</span> rosybrown1 


<span style='padding:1em; background-color: rgb(238, 180, 180);'>&nbsp;</span> rosybrown2 


<span style='padding:1em; background-color: rgb(205, 155, 155);'>&nbsp;</span> rosybrown3 


<span style='padding:1em; background-color: rgb(139, 105, 105);'>&nbsp;</span> rosybrown4 


<span style='padding:1em; background-color: rgb(65, 105, 225);'>&nbsp;</span> royalblue 


<span style='padding:1em; background-color: rgb(72, 118, 255);'>&nbsp;</span> royalblue1 


<span style='padding:1em; background-color: rgb(67, 110, 238);'>&nbsp;</span> royalblue2 


<span style='padding:1em; background-color: rgb(58, 95, 205);'>&nbsp;</span> royalblue3 


<span style='padding:1em; background-color: rgb(39, 64, 139);'>&nbsp;</span> royalblue4 


<span style='padding:1em; background-color: rgb(139, 69, 19);'>&nbsp;</span> saddlebrown 


<span style='padding:1em; background-color: rgb(250, 128, 114);'>&nbsp;</span> salmon 


<span style='padding:1em; background-color: rgb(255, 140, 105);'>&nbsp;</span> salmon1 


<span style='padding:1em; background-color: rgb(238, 130, 98);'>&nbsp;</span> salmon2 


<span style='padding:1em; background-color: rgb(205, 112, 84);'>&nbsp;</span> salmon3 


<span style='padding:1em; background-color: rgb(139, 76, 57);'>&nbsp;</span> salmon4 


<span style='padding:1em; background-color: rgb(244, 164, 96);'>&nbsp;</span> sandybrown 


<span style='padding:1em; background-color: rgb(46, 139, 87);'>&nbsp;</span> seagreen 


<span style='padding:1em; background-color: rgb(84, 255, 159);'>&nbsp;</span> seagreen1 


<span style='padding:1em; background-color: rgb(78, 238, 148);'>&nbsp;</span> seagreen2 


<span style='padding:1em; background-color: rgb(67, 205, 128);'>&nbsp;</span> seagreen3 


<span style='padding:1em; background-color: rgb(46, 139, 87);'>&nbsp;</span> seagreen4 


<span style='padding:1em; background-color: rgb(255, 245, 238);'>&nbsp;</span> seashell 


<span style='padding:1em; background-color: rgb(255, 245, 238);'>&nbsp;</span> seashell1 


<span style='padding:1em; background-color: rgb(238, 229, 222);'>&nbsp;</span> seashell2 


<span style='padding:1em; background-color: rgb(205, 197, 191);'>&nbsp;</span> seashell3 


<span style='padding:1em; background-color: rgb(139, 134, 130);'>&nbsp;</span> seashell4 


<span style='padding:1em; background-color: rgb(160, 82, 45);'>&nbsp;</span> sienna 


<span style='padding:1em; background-color: rgb(255, 130, 71);'>&nbsp;</span> sienna1 


<span style='padding:1em; background-color: rgb(238, 121, 66);'>&nbsp;</span> sienna2 


<span style='padding:1em; background-color: rgb(205, 104, 57);'>&nbsp;</span> sienna3 


<span style='padding:1em; background-color: rgb(139, 71, 38);'>&nbsp;</span> sienna4 


<span style='padding:1em; background-color: rgb(135, 206, 235);'>&nbsp;</span> skyblue 


<span style='padding:1em; background-color: rgb(135, 206, 255);'>&nbsp;</span> skyblue1 


<span style='padding:1em; background-color: rgb(126, 192, 238);'>&nbsp;</span> skyblue2 


<span style='padding:1em; background-color: rgb(108, 166, 205);'>&nbsp;</span> skyblue3 


<span style='padding:1em; background-color: rgb(74, 112, 139);'>&nbsp;</span> skyblue4 


<span style='padding:1em; background-color: rgb(106, 90, 205);'>&nbsp;</span> slateblue 


<span style='padding:1em; background-color: rgb(131, 111, 255);'>&nbsp;</span> slateblue1 


<span style='padding:1em; background-color: rgb(122, 103, 238);'>&nbsp;</span> slateblue2 


<span style='padding:1em; background-color: rgb(105, 89, 205);'>&nbsp;</span> slateblue3 


<span style='padding:1em; background-color: rgb(71, 60, 139);'>&nbsp;</span> slateblue4 


<span style='padding:1em; background-color: rgb(112, 128, 144);'>&nbsp;</span> slategray 


<span style='padding:1em; background-color: rgb(198, 226, 255);'>&nbsp;</span> slategray1 


<span style='padding:1em; background-color: rgb(185, 211, 238);'>&nbsp;</span> slategray2 


<span style='padding:1em; background-color: rgb(159, 182, 205);'>&nbsp;</span> slategray3 


<span style='padding:1em; background-color: rgb(108, 123, 139);'>&nbsp;</span> slategray4 


<span style='padding:1em; background-color: rgb(112, 128, 144);'>&nbsp;</span> slategrey 


<span style='padding:1em; background-color: rgb(255, 250, 250);'>&nbsp;</span> snow 


<span style='padding:1em; background-color: rgb(255, 250, 250);'>&nbsp;</span> snow1 


<span style='padding:1em; background-color: rgb(238, 233, 233);'>&nbsp;</span> snow2 


<span style='padding:1em; background-color: rgb(205, 201, 201);'>&nbsp;</span> snow3 


<span style='padding:1em; background-color: rgb(139, 137, 137);'>&nbsp;</span> snow4 


<span style='padding:1em; background-color: rgb(0, 255, 127);'>&nbsp;</span> springgreen 


<span style='padding:1em; background-color: rgb(0, 255, 127);'>&nbsp;</span> springgreen1 


<span style='padding:1em; background-color: rgb(0, 238, 118);'>&nbsp;</span> springgreen2 


<span style='padding:1em; background-color: rgb(0, 205, 102);'>&nbsp;</span> springgreen3 


<span style='padding:1em; background-color: rgb(0, 139, 69);'>&nbsp;</span> springgreen4 


<span style='padding:1em; background-color: rgb(70, 130, 180);'>&nbsp;</span> steelblue 


<span style='padding:1em; background-color: rgb(99, 184, 255);'>&nbsp;</span> steelblue1 


<span style='padding:1em; background-color: rgb(92, 172, 238);'>&nbsp;</span> steelblue2 


<span style='padding:1em; background-color: rgb(79, 148, 205);'>&nbsp;</span> steelblue3 


<span style='padding:1em; background-color: rgb(54, 100, 139);'>&nbsp;</span> steelblue4 


<span style='padding:1em; background-color: rgb(210, 180, 140);'>&nbsp;</span> tan 


<span style='padding:1em; background-color: rgb(255, 165, 79);'>&nbsp;</span> tan1 


<span style='padding:1em; background-color: rgb(238, 154, 73);'>&nbsp;</span> tan2 


<span style='padding:1em; background-color: rgb(205, 133, 63);'>&nbsp;</span> tan3 


<span style='padding:1em; background-color: rgb(139, 90, 43);'>&nbsp;</span> tan4 


<span style='padding:1em; background-color: rgb(216, 191, 216);'>&nbsp;</span> thistle 


<span style='padding:1em; background-color: rgb(255, 225, 255);'>&nbsp;</span> thistle1 


<span style='padding:1em; background-color: rgb(238, 210, 238);'>&nbsp;</span> thistle2 


<span style='padding:1em; background-color: rgb(205, 181, 205);'>&nbsp;</span> thistle3 


<span style='padding:1em; background-color: rgb(139, 123, 139);'>&nbsp;</span> thistle4 


<span style='padding:1em; background-color: rgb(255, 99, 71);'>&nbsp;</span> tomato 


<span style='padding:1em; background-color: rgb(255, 99, 71);'>&nbsp;</span> tomato1 


<span style='padding:1em; background-color: rgb(238, 92, 66);'>&nbsp;</span> tomato2 


<span style='padding:1em; background-color: rgb(205, 79, 57);'>&nbsp;</span> tomato3 


<span style='padding:1em; background-color: rgb(139, 54, 38);'>&nbsp;</span> tomato4 


<span style='padding:1em; background-color: rgb(64, 224, 208);'>&nbsp;</span> turquoise 


<span style='padding:1em; background-color: rgb(0, 245, 255);'>&nbsp;</span> turquoise1 


<span style='padding:1em; background-color: rgb(0, 229, 238);'>&nbsp;</span> turquoise2 


<span style='padding:1em; background-color: rgb(0, 197, 205);'>&nbsp;</span> turquoise3 


<span style='padding:1em; background-color: rgb(0, 134, 139);'>&nbsp;</span> turquoise4 


<span style='padding:1em; background-color: rgb(238, 130, 238);'>&nbsp;</span> violet 


<span style='padding:1em; background-color: rgb(208, 32, 144);'>&nbsp;</span> violetred 


<span style='padding:1em; background-color: rgb(255, 62, 150);'>&nbsp;</span> violetred1 


<span style='padding:1em; background-color: rgb(238, 58, 140);'>&nbsp;</span> violetred2 


<span style='padding:1em; background-color: rgb(205, 50, 120);'>&nbsp;</span> violetred3 


<span style='padding:1em; background-color: rgb(139, 34, 82);'>&nbsp;</span> violetred4 


<span style='padding:1em; background-color: rgb(245, 222, 179);'>&nbsp;</span> wheat 


<span style='padding:1em; background-color: rgb(255, 231, 186);'>&nbsp;</span> wheat1 


<span style='padding:1em; background-color: rgb(238, 216, 174);'>&nbsp;</span> wheat2 


<span style='padding:1em; background-color: rgb(205, 186, 150);'>&nbsp;</span> wheat3 


<span style='padding:1em; background-color: rgb(139, 126, 102);'>&nbsp;</span> wheat4 


<span style='padding:1em; background-color: rgb(245, 245, 245);'>&nbsp;</span> whitesmoke 


<span style='padding:1em; background-color: rgb(255, 255, 0);'>&nbsp;</span> yellow 


<span style='padding:1em; background-color: rgb(255, 255, 0);'>&nbsp;</span> yellow1 


<span style='padding:1em; background-color: rgb(238, 238, 0);'>&nbsp;</span> yellow2 


<span style='padding:1em; background-color: rgb(205, 205, 0);'>&nbsp;</span> yellow3 


<span style='padding:1em; background-color: rgb(139, 139, 0);'>&nbsp;</span> yellow4 


<span style='padding:1em; background-color: rgb(154, 205, 50);'>&nbsp;</span> yellowgreen 

### ColourBrewer with ggplot {- #color-brewer}

See: http://ggplot2.tidyverse.org/reference/scale_brewer.html
