# PeSuT
VLC extension to translate english subtitle to persian using google translate.   
افزونه وی‌ال‌سی برای ترجمه زیرنویس انگلیسی به فارسی توسط گوگل ترنزلیت      
Idea(s): enjoying & learning other languages + watch just released movies + learn about lua codes   
ایده(ها): لذت بردن و یادگیری زبان‌های دیگر + تماشای فیلم‌های تازه منتشرشده + یادگیری کدهای زبان برنامه‌نویسی لوا   
Developer(s): <a href="https://github.com/bakhshiali">Ali Bakhshi</a>, </a href="https://www.researchgate.net/profile/Mahya-Bakhshi-2">Mahya Bakhshi</a>, <a href="https://www.researchgate.net/profile/Farzaneh-Ostovarpour">Farzaneh Ostovarpour</a>, <a href="https://www.researchgate.net/profile/Mohammad-Sadegh-Abbassi-Shanbehbazari">Mohammad Sadegh Abbassi Shanbehbazari</a>   
توسعه‌دهنده: علی بخشی، مهیا بخشی، فرزانه استوارپور، محمدصادق عباسی شنبه‌بازاری    

How to use?
---
INSTALLATION:   
	Paste the file (PeSuT.lua) in the VLC sub-direction /lua/extensions   
	Default roots in defferent OS:   
	* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\   
	* Windows (current user): %APPDATA%\VLC\lua\extensions\   
	* Linux (all users): /usr/share/vlc/lua/extensions/   
	* Linux (current user): ~/.local/share/vlc/lua/extensions/   
	* Mac OS X (all users): /Applications/VLC.app/Contents/MacOS/share/lua/extensions/   
	
Notes
---
	Note: create directories if it don't exist! & Restart the VLC!
	Run: Open VLC-->View--> مترجم زیرنویس فارسی and select it.-->Enable extension to translate current english subtitle.
	Note: subtitle file name should be the same as movie name.srt.
	Note: to avoid any crashing, run extension & close the vlc; the background vlc will translate the subtitle and
	the *-fa.srt will get larger in size; after a while the translation is done and the file size won't change anymore;
	there run the vlc and watch the movie with the translated subtitle in the same folder!
  
Language supports
---
Change the TARGET_LANG = "fa" as you desire to get translation.
e.g.: 
1) TARGET_LANG = "iw" for Hebrew
2) TARGET_LANG = "ru" for Russian
3) TARGET_LANG = "zh-CN" for Chinese (Simplified)
4) TARGET_LANG = "de" for German (deutsch)
5) ...


similar codes to learn about
---
1) https://github.com/nopium/vlc-trans-lua
2) https://github.com/exebetche/vlsub
3) https://gist.github.com/furious/b88f053f8c5c3b155e172d850276edbb

Future developments
---
1) drop-down menu for language selection
2) multi-line consideration
3) special characters
4) NLP implementations
5) Real-time translation (dumping in different threads)
6) ...
