# ncnu fpga team1期末專案 
作者：109352013 吳彥霖 109352010 柏彥丞 109352001 陳映羽

功能說明:
degital design final project
一個簡易電子時鐘，可以計時，從00:00開始計時(分:秒)，按下暫停鍵蜂鳴器會鳴叫，可按清除鑑使時間歸0。

input/output:
時間顯示位置(七段顯示器)
![image](https://user-images.githubusercontent.com/114101580/211266150-4d71b922-d7bf-4eb8-b407-dbbd9b628d74.png)

指撥開關控制時間暫停，暫停時蜂鳴器鳴叫
![image](https://user-images.githubusercontent.com/114101580/211266358-a11f5ce3-a4c5-4e54-8567-3b749fed3de9.png)

輕觸開關控制清除時間(歸0)
![image](https://user-images.githubusercontent.com/114101580/211266494-8f6462b8-36cb-4b79-a5cf-d3266e0af9b5.png)

程式模組說明:
module clock(output reg [6:0] seg,//com選擇的七段顯示器seg_m1,//分鐘的較高位的七段顯示器,//seg_m0分鐘的較低位的七段顯示器seg_s1,//秒鐘的較高位的七段顯示器seg_s0,//秒鐘的較低位的七段顯示器 output reg [3:0] com,//com用來選擇當前的七段顯示器output reg buzzer,//蜂鳴器控制 input clk,//colck clear ,//時間重置 input pause_time//時間暫停); 
module div_freq(input clk ,output reg clk_div,output reg scr_clk_div);//產生clock
