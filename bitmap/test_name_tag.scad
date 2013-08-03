include <../bitmap/name_tag.scad>;

translate([0,0,0])
name_tag(["n","a","m","e","_","t","a","g"], 8);

translate([20,0,0]) // 0 + 16/2 + 16/2 + 4
name_tag(["N","A","M","E","_","T","A","G"], 8);

translate([52,0,0]) // 20 + 16/2 + 40/2 + 4
name_tag(chars=["n","a","m","e","_","t","a","g"], char_count=8, block_size=5);

translate([96,0,0]) // 52 + 40/2 + 40/2 + 4
name_tag(chars=["N","A","M","E","_","T","A","G"], char_count=8, block_size=5);

translate([130,0,0]) // 92 + 40/2 + 16/2 + 4
name_tag(["n","a","m","e","_","t","a","g"], char_count=8, height=30);

translate([150,0,0]) // 130 + 16/2 + 16/2 + 4
name_tag(["N","A","M","E","_","T","A","G"], char_count=8, height=30);
