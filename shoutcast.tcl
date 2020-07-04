# shoutcast.tcl v1.03 by domsen <domsen@domsen.org> (c)2oo5
#
# comments? bugs? ideas? requests? money? beer?
# plz mail me or visit my homepage @ www.domsen.org
# visit #newsticker@ircnet
#
#
###############################################################
# shoutcast.tcl v1.03 by Chino <chino@canal-ayuda.org> (c)2oo6
# "TCL con Permiso, Editado y Traducido con credito a domsen."
#
# Favor no tocar nada de lo que no entiendas de haber
# algún problema no es responsabilidad mia ni de domsen
#
# Colores usados: Negro Azul Rojo Marrón y Fucsia
#
# Para cualquier ayuda me encuentra en:
# < #Ayuda #Trujilo #Ayuda-Eggdrop > <eu.Undernet.oRG>
#
# No quitar los creditos dados a:
#
# - domsen
# - Chino
# - #Ayuda-Eggdrop
#
###############################################################
# Saludos:
# A Spinetta que aportó mucho con la traducción.
#
###############################################################
# Configuracion ##################################################

set radiochans ""
set adminchans "#djs-boom"

set streamip "xxxxx"
set streamport "xxxxxx"
set streampass "xxxxxxxxx"

#set scstatstrigger "!estado"
#set scstreamtrigger "!enlace"
set scplayingtrigger "!sonando"
#set sclistenertrigger "!oyentes"
set scdjtrigger "!emite"
set scsetdjtrigger "!cabina"
set scunsetdjtrigger ".noserdj"
set scwishtrigger "!pedidos"
set scgreettrigger "!saludos"
set sclastsongstrigger "!ultimas"
#set schelptrigger "!radio"


set alertadmin ""
set doalertadmin "1"

set announce "1"

set urltopic "0"
set ctodjc "1"
set tellsongs "1"
set tellusers "1"
set tellbitrate "1"

set advertise "1"
set advertiseonlyifonline "1"

set offlinetext "La Radio Esta 4APAGADA !!!"
set offlinetopic ""

set onlinetext "1Radio IRC 6TRANSMITIENDO a 4 /bitrate/  kbits 1Sitonizanos en -> 12http://$streamip:$streamport/listen.pls"
set onlinetopic "Cambiar el topic"

set streamtext "Sintoniza Radio IRC en www.Sonidomegga.com"

set advertisetext ""


# end of config #####################


#bind pub - $scstatstrigger pub_scstat
#bind msg - $scstatstrigger msg_scstat

bind pub - $scplayingtrigger pub_playing
#bind msg - $scplayingtrigger msg_playing

bind pub - $scdjtrigger pub_dj
#bind msg - $scdjtrigger msg_dj

bind pub D $scsetdjtrigger pub_setdj
#bind msg D $scsetdjtrigger msg_setdj

#bind pub D $scunsetdjtrigger pub_unsetdj
#bind msg D $scunsetdjtrigger msg_unsetdj

bind pub - $scwishtrigger pub_wish
#bind msg - $scwishtrigger msg_wish

bind pub - $scgreettrigger pub_greet
#bind msg - $scgreettrigger msg_greet

#bind pub - $scstreamtrigger pub_stream
#bind msg - $scstreamtrigger msg_stream

#bind pub - $sclastsongstrigger pub_lastsongs
#bind msg - $sclastsongstrigger msg_lastsongs

#bind pub - $sclistenertrigger pub_listener
#bind msg - $sclistenertrigger msg_listener

#bind pub - $schelptrigger pub_help
#bind msg - $schelptrigger msg_help

#bind time - "* * * * *" envivo
bind time - "00 * * * *" advertise
bind time - "15 * * * *" advertise
bind time - "30 * * * *" advertise
bind time - "45 * * * *" advertise
bind nick f * djnickchange

bind pub - !pagina pub_pagina
bind pub D !peticion pub_peticiones
bind pub D !auto pub_auto
bind pub - !boom pub_boom

bind pub D !boom.adddj addDj
bind msg - !addhost msg_addhost
bind pub D !boom.join proc_join
bind pub D !boom.part proc_part
bind pub n !die proc_die

set dj ""
set ciudad ""
set peticiones ""
set surl ""
set bitrate ""
set stitle ""

if {[file exists dj]} {
set temp [open "dj" r]
set dj [gets $temp]
close $temp
}

if {[file exists ciudad]} {
set temp [open "ciudad" r]
set ciudad [gets $temp]
close $temp
}

if {[file exists peticiones]} {
set temp [open "peticiones" r]
set peticiones [gets $temp]
close $temp
}

proc proc_die { nick uhost hand chan text } {
 if {$text == ""} {
  die $nick
 } else { die $text }
}

proc proc_join {nick host handle chan text} {
global botnick adminchans
 if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans== "")} {
	if {[validchan $text]} {
		putserv "PRIVMSG $chan :\002$botnick\002 ya esta asignado a \002$text\002 ."
		return 1
	}
	channel add $text
	putserv "PRIVMSG $chan :\002$botnick\002 ha entrado en \002$text\002  ."
 }
}

proc proc_part {nick host handle chan text} {
global botnick adminchans
 if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans== "")} {
	if {![validchan $text]} {
		putserv "PRIVMSG $chan :\002$botnick\002 no se encuentra en \002$text\002 ."
		return 1
	}
	channel remove $text
	putserv "PRIVMSG $chan :\002$botnick\002 ha salido de \002$text\002  ."

 }
}



proc addDj { nick uhost hand chan text } {
global adminchans
 if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans== "")} {
	set addusernick [nick2hand $text]
	set thost [getchanhost $text $chan]
	set thost [split $thost "@"]
	set thost [lrange $thost 1 end]

    if {[validuser $addusernick]} {
      putserv "PRIVMSG $chan :\002$nick\002, $text ya se encuentra registrado como DJ"
    } else  {

      adduser $text $text!*@$thost
      chattr $text +D 
      putlog "\002$nick\002 ha agregado a  \002$text!*@$thost\002 a mi Database"
      putserv "PRIVMSG $chan :He Agregado a \002$text\002 en mi Database con el handle \002 $text!*@$thost \002"
      putserv "PRIVMSG $chan :En caso de cambiar el vhost usar el comando !addhost en mi privado"

      unset addusernick
    }
 }
}

proc msg_addhost {nick uhost handle text} {
set nickip [maskhost $nick!$uhost 7]
setuser $nick hosts $nickip
putlog "Actualizando handle de $nick $nickip"
putserv "PRIVMSG $nick :Has actualizado tu vhost en el acceso del bot: \002$nickip\002"
}



proc pub_auto { nick uhost hand chan arg } { 
global adminchans
 if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans== "")} {

   set temp [open "peticiones" w+]
    puts $temp "Cerradas"
   close $temp

   set temp [open "dj" w+]
    puts $temp "Auto-Boom"
   close $temp

   set temp [open "ciudad" w+]
    puts $temp "Colombia"
   close $temp
        
   poststuff privmsg "\002\0032Ahora Se Procedera a Cambiar La Radio a \00310Auto-Boom. \0036Radio BooM \003Una Explosion \0036De\003 Sonidos"
 }
}

proc pub_pagina { nick uhost hand chan arg } { 
putserv "privmsg $chan :\002\0033$nick \0032Visita Nuestro Pagina \0036Oficial: \003https://radio-boom.wixsite.com/boom"
}

proc pub_peticiones { nick uhost hand chan text } {
global adminchans
 
       if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans== "")} {
           set temp [open "dj" r]
              set dj [gets $temp]
           close $temp
	  if {$text=="on"} {
       		set temp [open "peticiones" w+]
       		  puts $temp "Abiertas"
       		close $temp

        	#putserv "privmsg $adminchans1 :PETICIONES: Las Peticiones han sido abierta"
        	poststuff privmsg "PETICIONES: $dj abrio las peticiones"
	  } elseif {$text=="off"} {
       		set temp [open "peticiones" w+]
       		  puts $temp "Cerradas"
       		close $temp

        	#putserv "privmsg $adminchans1 :PETICIONES: Las Peticiones han sido abierta"
        	poststuff privmsg "PETICIONES: $dj cerro las peticiones"
	  } else {
	    putserv "privmsg $adminchans : $nick Comando Erroneo por favor usar !peticion on/off"
	  }

	}
}


proc shrink { calc number string start bl} { return [expr [string first "$string" $bl $start] $calc $number] }


proc status { } {
global streamip streamport streampass
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]
}}
close $sock
}
if { $streamstatus == "1" } { return 1 } else { return 0 }
}




proc poststuff { mode text } {
global radiochans dj
set curlist "0"
set curhigh "0"
set surl ""
set cursong ""
set sgenre ""
set bitrate "0"
set stitle ""

set temp [open "envivo" r]
while {[eof $temp] != 1} {
set zeile [gets $temp]
if {[string first "curlist:" $zeile] != -1 } { set curlist $zeile }
if {[string first "curhigh:" $zeile] != -1 } { set curhigh $zeile }
if {[string first "cursong:" $zeile] != -1 } { set cursong [lrange $zeile 1 [llength $zeile]]] }
if {[string first "sgenre:" $zeile] != -1 } { set sgenre [lrange $zeile 1 [llength $zeile]]}
if {[string first "serverurl:" $zeile] != -1 } { set surl [lindex $zeile 1] }
if {[string first "bitrate:" $zeile] != -1 } { set bitrate [lindex $zeile 1] }
if {[string first "stitle:" $zeile] != -1 } { set stitle [lindex $zeile 1] }
}
close $temp

regsub -all "/stitle/" $text "$stitle" text
regsub -all "/curlist/" $text "$curlist" text
regsub -all "/curhigh/" $text "$curhigh" text
regsub -all "/cursong/" $text "$cursong" text
regsub -all "/sgenre/" $text "$sgenre" text
regsub -all "/surl/" $text "$surl" text
regsub -all "/bitrate/" $text "$bitrate" text
regsub -all "/dj/" $text "$dj" text

foreach chan [channels] {
if {$radiochans == "" } { putserv "$mode $chan :$text" }
if {$radiochans != "" } {
if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1)} {putserv "$mode $chan :$text"}
}}}


proc schelp { target } {
global scstatstrigger scstreamtrigger scplayingtrigger scdjtrigger sclastsongstrigger scwishtrigger scgreettrigger sclistenertrigger
putserv "notice $target :1Los Comandos Que Puede Usar Son:"
putserv "notice $target :4$scstatstrigger1: Ver el Estado - 4$scstreamtrigger1: Ver Nuestro Link - 4$scplayingtrigger1: Ver el SONG que esta actualmente Sonando - 4$scdjtrigger1: Ver Nuestro Actual DJ de la Radio - 4$sclastsongstrigger1: Ver Las 10 ULTIMAS Song sonadas en radio - 4$scwishtrigger1: Mandar pedidos Musicales Ej: $scwishtrigger <tus_songs> - 4$scgreettrigger1: Mandar Tus Mensaje de Saludos Ej: $scgreettrigger <tus_saludos> 4$sclistenertrigger1: Ver N° Actual de Oyentes "
putserv "notice $target :1Radio IRC ->> 5http://radioirc.sytes.net:8000/listen.pls51 - domsen & Chino"
}


proc pub_help {nick uhost hand chan arg} {
global radiochans
if {$radiochans == "" } { schelp $nick }
if {$radiochans != "" } {
if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { schelp $nick}
}}

proc advertise { nick uhost hand chan arg } {
global advertisetext advertise advertiseonlyifonline
global streamip streamport streampass dj

if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]
set songtitle [string range $bl [shrink + 11 "<SONGTITLE" 0 $bl] [shrink - 1 "</SONGTITLE>" 0 $bl]]
set songurl [string range $bl [shrink + 9 "<SONGURL>" 0 $bl] [shrink - 1 "</SONGURL>" 0 $bl]]
if {$songurl != ""} { set songurl " ($songurl)"}
regsub -all "&#x3C;" $songtitle "<" songtitle
regsub -all "&#x3E;" $songtitle ">" songtitle
regsub -all "&#x26;" $songtitle "+" songtitle  
regsub -all "&#x22;" $songtitle "\"" songtitle
regsub -all "&#x27;" $songtitle "'" songtitle
regsub -all "&#xFF;" $songtitle "" songtitle
regsub -all "&#xB4;" $songtitle "´" songtitle
regsub -all "&#x96;" $songtitle "-" songtitle
regsub -all "&#xF6;" $songtitle "ö" songtitle
regsub -all "&#xE4;" $songtitle "ä" songtitle
regsub -all "&#xFC;" $songtitle "ü" songtitle
regsub -all "&#xD6;" $songtitle "Ö" songtitle
regsub -all "&#xC4;" $songtitle "Ä" songtitle
regsub -all "&#xDC;" $songtitle "Ü" songtitle
regsub -all "&#xDF;" $songtitle "ß" songtitle
regsub -all "&#xC1;" $songtitle "Á" songtitle
regsub -all "&#xC9;" $songtitle "É" songtitle
regsub -all "&#xCD;" $songtitle "Í" songtitle
regsub -all "&#xD3;" $songtitle "Ó" songtitle
regsub -all "&#xDA;" $songtitle "Ú" songtitle
regsub -all "&#xE1;" $songtitle "á" songtitle
regsub -all "&#xE9;" $songtitle "é" songtitle
regsub -all "&#xED;" $songtitle "í" songtitle
regsub -all "&#xF3;" $songtitle "ó" songtitle
regsub -all "&#xFA;" $songtitle "ú" songtitle
regsub -all "&#xF1;" $songtitle "ñ" songtitle


set temp [open "dj" r]
set dj [gets $temp]
close $temp
set temp [open "peticiones" r]
set peticiones [gets $temp]
close $temp
set temp [open "ciudad" r]
set ciudad [gets $temp]
close $temp

if {$streamstatus == 1} { 
poststuff privmsg "\002\0032En Cabina: \003Nuestro Locutor ¤¦ \0034$dj\003 ¦¤ Desde ¤¦ \0034$ciudad\003 ¦¤ \0032Escuchanos por \003https://radio-boom.wixsite.com/boom \0032- Peticiones \0034$peticiones\0032 Sonando:\00310 $songtitle  "
 }

}}
close $sock
}}


proc setdj {nickname ciudad } {
global adminchans
if {$ciudad == "" } { putserv "privmsg $adminchans :Por favor ingresar el comando correcto !cabina <ciudad>"; return 0 }
global streamip streamport streampass dj
putlog "shoutcast: Nuevo Dj: $nickname de la ciudad $ciudad"
set temp [open "dj" w+]
puts $temp $nickname
close $temp

set temp [open "ciudad" w+]
puts $temp $ciudad
close $temp

if { [status] == "1" } { poststuff privmsg "$nickname Es Ahora Nuestro DJ."
if { $::ctodjc == "1" } {
set temp [open "envivo" r]
while {[eof $temp] != 1} {
set zeile [gets $temp]
if {[string first "envivo:" $zeile] != -1 } { set oldenvivo $zeile }
if {[string first "curlist:" $zeile] != -1 } { set oldcurlist $zeile }
if {[string first "curhigh:" $zeile] != -1 } { set oldcurhigh $zeile }
if {[string first "cursong:" $zeile] != -1 } { set oldsong $zeile }
if {[string first "bitrate:" $zeile] != -1 } { set oldbitrate $zeile }
}
close $temp
}
} else {
putserv "privmsg $adminchans :Comando invalido por tener el servidor OFF Line" }
}


proc msg_setdj { nick uhost hand arg } { setdj $nick $arg }
proc pub_setdj { nick uhost hand chan arg } { global adminchans; if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans == "")} { setdj $nick $arg }}

proc unsetdj { nick } {
global dj
set dj ""
file delete dj
putserv "notice $nick :Dj Borrado .. Puede Entrar otro Dj Poniendo el Comando .setdj Nickname"
}



proc msg_unsetdj { nick uhost hand arg } { unsetdj $nick }
proc pub_unsetdj { nick uhost hand chan arg } { global adminchans; if {([lsearch -exact [string tolower $adminchans] [string tolower $chan]] != -1) || ($adminchans == "")} { unsetdj $nick }}


proc listener { target } {
global streamip streamport streampass
putlog "Radio: $target Pedido De Conteo de Oyentes"
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set repl [string range $bl [shrink + 18 "<CURRENTLISTENERS>" 0 $bl] [shrink - 1 "</CURRENTLISTENERS>" 0 $bl]]
set curhigh [string range $bl [shrink + 15 "<PEAKLISTENERS>" 0 $bl] [shrink - 1 "</PEAKLISTENERS>" 0 $bl]]
set maxl [string range $bl [shrink + 14 "<MAXLISTENERS>" 0 $bl] [shrink - 1 "</MAXLISTENERS>" 0 $bl]]
set avgtime [string range $bl [shrink + 13 "<AVERAGETIME>" 0 $bl] [shrink - 1 "</AVERAGETIME>" 0 $bl]]}}
close $sock
putserv "notice $target :Actualmente hay $repl Oyente(s), La Radio Tiene Capacidad para $maxl Oyentes, el número máximo de Oyentes Hasta Ahora es de $curhigh Oyentes, el promedio de escucha es a $avgtime"
}}

proc msg_listener { nick uhost hand arg } { listener $nick }
proc pub_listener { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { listener $nick }}

proc wish { nick arg } {
if {$arg == ""} { putserv "notice $nick :"; return 0}
if { [status] == "1" } {
set temp [open "djnick" r]
set djnick [gets $temp]
close $temp
putserv "privmsg $djnick :PEDIDO MUSICAL: $arg de Parte de $nick"
} else {
putserv "notice $nick :" }
}


proc msg_wish { nick uhost hand arg } { wish $nick $arg }
proc pub_wish { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { wish $nick $arg }}




proc sclastsongs { target } {
global streamip streamport streampass
putlog "Radio: $target Pedidos las Song ultimas"
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set songs [string range $bl [string first "<title>" $bl] [expr [string last "</title>" $bl] + 7]]

regsub -all "&#x3C;" $songs "<" songs
regsub -all "&#x3E;" $songs ">" songs
regsub -all "&#x26;" $songs "+" songs
regsub -all "&#x22;" $songs "\"" songs
regsub -all "&#x27;" $songs "'" songs
regsub -all "&#xFF;" $songs "" songs
regsub -all "<title>" $songs "(" songs
regsub -all "</title>" $songs ")" songs
regsub -all "" $songs "" songs
regsub -all "" $songs " - " songs
regsub -all "" $songs "" songs
regsub -all "" $songs "" songs
regsub -all {\d} $songs "" songs

regsub -all "&#xB4;" $songs "´" songs
regsub -all "&#x96;" $songs "-" songs
regsub -all "&#xF6;" $songs "ö" songs
regsub -all "&#xE4;" $songs "ä" songs
regsub -all "&#xFC;" $songs "ü" songs
regsub -all "&#xD6;" $songs "Ö" songs
regsub -all "&#xC4;" $songs "Ä" songs
regsub -all "&#xDC;" $songs "Ü" songs
regsub -all "&#xDF;" $songs "ß" songs
regsub -all "&#xC1;" $songs "Á" songs
regsub -all "&#xC9;" $songs "É" songs
regsub -all "&#xCD;" $songs "Í" songs
regsub -all "&#xD3;" $songs "Ó" songs
regsub -all "&#xDA;" $songs "Ú" songs
regsub -all "&#xE1;" $songs "á" songs
regsub -all "&#xE9;" $songs "é" songs
regsub -all "&#xED;" $songs "í" songs
regsub -all "&#xF3;" $songs "ó" songs
regsub -all "&#xFA;" $songs "ú" songs
regsub -all "&#xF1;" $songs "ñ" songs

}}
close $sock
putserv "notice $target :$songs"
}}


proc msg_lastsongs { nick uhost hand arg } { sclastsongs $nick }
proc pub_lastsongs { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { sclastsongs $nick }}



proc scstream { target } {
global streamip streamport streamtext
putlog "Radio: Informacion pedida por $target"
putserv "notice $target :$streamtext"
}

proc msg_stream { nick uhost hand arg } { scstream $nick }
proc pub_stream { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { scstream $nick }}

proc scgreet { nick arg } {
if {$arg == ""} { putserv "notice $nick :"; return 0}
if { [status] == "1" } {
set temp [open "djnick" r]
set djnick [gets $temp]
close $temp
putserv "privmsg $djnick :(Saludo) - $nick - $arg"
} else {
putserv "notice $nick :" }
}


proc msg_greet { nick uhost hand arg } { scgreet $nick $arg }
proc pub_greet { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { scgreet $nick $arg }}



proc djnickchange { oldnick uhost hand chan newnick } {
set temp [open "djnick" r]
set djnick [gets $temp]
close $temp
if {$oldnick == $djnick} {
putlog "Radio: Cambia de Nick del Dj $oldnick -> $newnick"
set temp [open "djnick" w+]
puts $temp $newnick
close $temp
}}





proc dj { target chan } {
global streamip streamport streampass dj
putlog "Radio: $target pidio la Informacio de Dj"
if {[status] == 1} {
if {[file exists dj]} {
set temp [open "dj" r]
set dj [gets $temp]
close $temp

putserv "privmsg $chan :\002\0032Emite: \0034$dj \0036Para Radio Boom \0032Una Explosion De Sonidos"

} else { putserv "notice $target :No hay ningun DJ seteado" }
} else { putserv "notice $target :La Radio se encuentra OFF Line" }
}




proc msg_dj { nick uhost hand arg } { dj $nick"}
proc pub_dj { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { dj $nick $chan }}



proc scstat {target} {
global streamip streamport streampass
putlog "Radio: $target Pidio el Estado de la Radio"
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]
set repl [string range $bl [shrink + 18 "<CURRENTLISTENERS>" 0 $bl] [shrink - 1 "</CURRENTLISTENERS>" 0 $bl]]
set curhigh [string range $bl [shrink + 15 "<PEAKLISTENERS>" 0 $bl] [shrink - 1 "</PEAKLISTENERS>" 0 $bl]]
set currentl [string range $bl [shrink + 18 "<CURRENTLISTENERS>" 0 $bl] [shrink - 1 "</CURRENTLISTENERS>" 0 $bl]]
set surl [string range $bl [shrink + 11 "<SERVERURL>" 0 $bl] [shrink - 1 "</SERVERURL>" 0 $bl]]
set maxl [string range $bl [shrink + 14 "<MAXLISTENERS>" 0 $bl] [shrink - 1 "</MAXLISTENERS>" 0 $bl]]
set bitrate [string range $bl [shrink + 9 "<BITRATE>" 0 $bl] [shrink - 1 "</BITRATE>" 0 $bl]]
set stitle [string range $bl [shrink + 13 "<SERVERTITLE>" 0 $bl] [shrink - 1 "</SERVERTITLE>" 0 $bl]]
set sgenre [string range $bl [shrink + 13 "<SERVERGENRE>" 0 $bl] [shrink - 1 "</SERVERGENRE>" 0 $bl]]
if {$sgenre != ""} {set sgenre " ($sgenre)"}
set avgtime [string range $bl [shrink + 13 "<AVERAGETIME>" 0 $bl] [shrink - 1 "</AVERAGETIME>" 0 $bl]]
set irc [string range $bl [shrink + 5 "<IRC>" 0 $bl] [shrink - 1 "</IRC>" 0 $bl]]
set icq [string range $bl [shrink + 5 "<ICQ>" 0 $bl] [shrink - 1 "</ICQ>" 0 $bl]]
if {$icq == 0} { set icq "N/A" }
set aim [string range $bl [shrink + 5 "<AIM>" 0 $bl] [shrink - 1 "</AIM>" 0 $bl]]
set webhits [string range $bl [shrink + 9 "<WEBHITS>" 0 $bl] [shrink - 1 "</WEBHITS>" 0 $bl]]
set streamhits [string range $bl [shrink + 12 "<STREAMHITS>" 0 $bl] [shrink - 1 "</STREAMHITS>" 0 $bl]]
set version [string range $bl [shrink + 9 "<VERSION>" 0 $bl] [shrink - 1 "</VERSION>" 0 $bl]]
if {$streamstatus == 1} {
if {[file exists dj]} {
set temp [open "dj" r]
set dj [gets $temp]
close $temp
} else { set dj "none" }
putserv "notice $target :Radio IRC ESTA EN LINEA, en shoutcast y Transmitiendo a $bitrate kbps, mas información en $surl"
} else {
putserv "notice $target :Radio IRC Actualmente ESTA APAGADA, Mas información en www.SonidoMegga.Com" }
putserv "notice $target :La Capacidad maxima de oyentes es $maxl, Total de Oyentes En la Radio fue de $curhigh oyentes."
putserv "notice $target :El tiempo promedio de escucha es de $avgtime segundos, La Radio tiene $webhits webhits y $streamhits streamhits."
putserv "notice $target :Tu puedes contactarte en el IRC en el canal $irc, Via Internet."
}}
close $sock
}}


proc msg_scstat { nick uhost hand arg } { scstat $nick}
proc pub_scstat { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { scstat $nick }}


proc playing {target chan} {
global streamip streamport streampass dj
putlog "shoutcast: $target pedido la canción actual"
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]
set songtitle [string range $bl [shrink + 11 "<SONGTITLE" 0 $bl] [shrink - 1 "</SONGTITLE>" 0 $bl]]
set songurl [string range $bl [shrink + 9 "<SONGURL>" 0 $bl] [shrink - 1 "</SONGURL>" 0 $bl]]
if {$songurl != ""} { set songurl " ($songurl)"}
regsub -all "&#x3C;" $songtitle "<" songtitle
regsub -all "&#x3E;" $songtitle ">" songtitle
regsub -all "&#x26;" $songtitle "+" songtitle  
regsub -all "&#x22;" $songtitle "\"" songtitle
regsub -all "&#x27;" $songtitle "'" songtitle
regsub -all "&#xFF;" $songtitle "" songtitle
regsub -all "&#xB4;" $songtitle "´" songtitle
regsub -all "&#x96;" $songtitle "-" songtitle
regsub -all "&#xF6;" $songtitle "ö" songtitle
regsub -all "&#xE4;" $songtitle "ä" songtitle
regsub -all "&#xFC;" $songtitle "ü" songtitle
regsub -all "&#xD6;" $songtitle "Ö" songtitle
regsub -all "&#xC4;" $songtitle "Ä" songtitle
regsub -all "&#xDC;" $songtitle "Ü" songtitle
regsub -all "&#xDF;" $songtitle "ß" songtitle
regsub -all "&#xF3;" $songtitle "ó" songtitle
regsub -all "&#xFA;" $songtitle "ú" songtitle
regsub -all "&#xC1;" $songtitle "Á" songtitle
regsub -all "&#xC9;" $songtitle "É" songtitle
regsub -all "&#xCD;" $songtitle "Í" songtitle
regsub -all "&#xD3;" $songtitle "Ó" songtitle
regsub -all "&#xDA;" $songtitle "Ú" songtitle
regsub -all "&#xE1;" $songtitle "á" songtitle
regsub -all "&#xE9;" $songtitle "é" songtitle
regsub -all "&#xED;" $songtitle "í" songtitle
regsub -all "&#xF3;" $songtitle "ó" songtitle
regsub -all "&#xFA;" $songtitle "ú" songtitle
regsub -all "&#xF1;" $songtitle "ñ" songtitle
 
if {$streamstatus == 1} {
putserv "privmsg $chan :\002\0033 $target \0036Suena \003 $songtitle "
} else {
putserv "notice $target :El servidor es Actualmente Fuera de Línea *4APAGADO*, Lo Siento"
}}}
close $sock
}}
 
proc msg_playing { nick uhost hand arg } { playing $nick}
proc pub_playing { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { playing $nick $chan }}




proc boom {target chan} {
global streamip streamport streampass dj
putlog "shoutcast: $target pedido comando !boom"
if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0 } else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]
set songtitle [string range $bl [shrink + 11 "<SONGTITLE" 0 $bl] [shrink - 1 "</SONGTITLE>" 0 $bl]]
set songurl [string range $bl [shrink + 9 "<SONGURL>" 0 $bl] [shrink - 1 "</SONGURL>" 0 $bl]]
if {$songurl != ""} { set songurl " ($songurl)"}
regsub -all "&#x3C;" $songtitle "<" songtitle
regsub -all "&#x3E;" $songtitle ">" songtitle
regsub -all "&#x26;" $songtitle "+" songtitle  
regsub -all "&#x22;" $songtitle "\"" songtitle
regsub -all "&#x27;" $songtitle "'" songtitle
regsub -all "&#xFF;" $songtitle "" songtitle
regsub -all "&#xB4;" $songtitle "´" songtitle
regsub -all "&#x96;" $songtitle "-" songtitle
regsub -all "&#xF6;" $songtitle "ö" songtitle
regsub -all "&#xE4;" $songtitle "ä" songtitle
regsub -all "&#xFC;" $songtitle "ü" songtitle
regsub -all "&#xD6;" $songtitle "Ö" songtitle
regsub -all "&#xC4;" $songtitle "Ä" songtitle
regsub -all "&#xDC;" $songtitle "Ü" songtitle
regsub -all "&#xDF;" $songtitle "ß" songtitle
regsub -all "&#xC1;" $songtitle "Á" songtitle
regsub -all "&#xC9;" $songtitle "É" songtitle
regsub -all "&#xCD;" $songtitle "Í" songtitle
regsub -all "&#xD3;" $songtitle "Ó" songtitle
regsub -all "&#xDA;" $songtitle "Ú" songtitle
regsub -all "&#xE1;" $songtitle "á" songtitle
regsub -all "&#xE9;" $songtitle "é" songtitle
regsub -all "&#xED;" $songtitle "í" songtitle
regsub -all "&#xF3;" $songtitle "ó" songtitle
regsub -all "&#xFA;" $songtitle "ú" songtitle
regsub -all "&#xF1;" $songtitle "ñ" songtitle

set temp [open "dj" r]
set dj [gets $temp]
close $temp
set temp [open "peticiones" r]
set peticiones [gets $temp]
close $temp
set temp [open "ciudad" r]
set ciudad [gets $temp]
close $temp

 
if {$streamstatus == 1} {
putserv "privmsg $chan : \002\0036$target \0032En Cabina: \003Nuestro Locutor ¤¦ \0034$dj\003 ¦¤ Desde ¤¦ \0034$ciudad\003 ¦¤ \0032Escuchanos por \003https://radio-boom.wixsite.com/boom \0032- Peticiones \0034$peticiones \0032Sonando: \00310$songtitle "
} else {
putserv "notice $target :El servidor es Actualmente Fuera de Línea *APAGADO*, Lo Siento"
}}}
close $sock
}}

proc pub_boom { nick uhost hand chan arg } { global radiochans; if {([lsearch -exact [string tolower $radiochans] [string tolower $chan]] != -1) || ($radiochans == "")} { boom $nick $chan }}






proc envivo { nick uhost hand chan arg } {
global radiochans announce tellusers tellsongs tellbitrate urltopic dj
global offlinetext offlinetopic onlinetext onlinetopic
global streamip streampass streamport dj
global doalertadmin alertadmin

if {$announce == 1 || $tellsongs == 1 || $tellusers == 1 || $tellbitrate == 1} {
set envivofile "envivo"
set oldenvivo "envivo: 0"
set oldcurlist "curlist: 0"
set oldcurhigh "curhigh: 0"
set oldsong "cursong: 0"
set oldbitrate "bitrate: 0"
if {[file exists $envivofile]} {
putlog "Radio: Viendo la Conexion de Radio"
set temp [open "envivo" r]
while {[eof $temp] != 1} {
set zeile [gets $temp]
if {[string first "envivo:" $zeile] != -1 } { set oldenvivo $zeile }
if {[string first "curlist:" $zeile] != -1 } { set oldcurlist $zeile }
if {[string first "curhigh:" $zeile] != -1 } { set oldcurhigh $zeile }
if {[string first "cursong:" $zeile] != -1 } { set oldsong $zeile }
if {[string first "bitrate:" $zeile] != -1 } { set oldbitrate $zeile }
}
close $temp
}


if {[catch {set sock [socket $streamip $streamport] } sockerror]} {
putlog "error: $sockerror"
return 0} else {
puts $sock "GET /admin.cgi?pass=$streampass&mode=viewxml&page=1 HTTP/1.0"
puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)"
puts $sock "Host: $streamip"
puts $sock "Connection: close"
puts $sock ""
flush $sock
while {[eof $sock] != 1} {
set bl [gets $sock]
if { [string first "standalone" $bl] != -1 } {
set streamstatus "envivo: [string range $bl [shrink + 14 "<STREAMSTATUS>" 0 $bl] [shrink - 1 "</STREAMSTATUS>" 0 $bl]]"
set repl "curlist: [string range $bl [shrink + 18 "<CURRENTLISTENERS>" 0 $bl] [shrink - 1 "</CURRENTLISTENERS>" 0 $bl]]"
set curhigh "curhigh: [string range $bl [shrink + 15 "<PEAKLISTENERS>" 0 $bl] [shrink - 1 "</PEAKLISTENERS>" 0 $bl]]"
set currentl [string range $bl [shrink + 18 "<CURRENTLISTENERS>" 0 $bl] [shrink - 1 "</CURRENTLISTENERS>" 0 $bl]]
set surl "serverurl: [string range $bl [shrink + 11 "<SERVERURL>" 0 $bl] [shrink - 1 "</SERVERURL>" 0 $bl]]"
set cursong "cursong: [string range $bl [shrink + 11 "<SONGTITLE" 0 $bl] [shrink - 1 "</SONGTITLE>" 0 $bl]]"
set songurl [string range $bl [shrink + 9 "<SONGURL>" 0 $bl] [shrink - 1 "</SONGURL>" 0 $bl]]
set bitrate "bitrate: [string range $bl [shrink + 9 "<BITRATE>" 0 $bl] [shrink - 1 "</BITRATE>" 0 $bl]]"
set stitle "stitle: [string range $bl [shrink + 13 "<SERVERTITLE>" 0 $bl] [shrink - 1 "</SERVERTITLE>" 0 $bl]]"
set sgenre "sgenre: [string range $bl [shrink + 13 "<SERVERGENRE>" 0 $bl] [shrink - 1 "</SERVERGENRE>" 0 $bl]]"
}}
close $sock
}

set temp [open "envivo" w+]
puts $temp "$streamstatus\n$repl\n$curhigh\n$cursong\n$bitrate\n$stitle\n$sgenre\n$surl"
close $temp
if {$announce == 1 } {
if {$streamstatus == "envivo: 0" && $oldenvivo == "envivo: 1"} {
poststuff privmsg $offlinetext
if {$doalertadmin == "1"} { sendnote domsen $alertadmin "" }
if {$urltopic == 1} { poststuff topic $offlinetopic }
}
if {$streamstatus == "envivo: 1" && $oldenvivo == "envivo: 0" } {
if {$sgenre != ""} {
set sgenre " ([lrange $sgenre 1 [llength $sgenre]] )"
}
poststuff privmsg "$onlinetext"
if {$urltopic == 1} { poststuff topic "$onlinetopic" }
}}
if {($tellusers == 1) && ($streamstatus == "envivo: 1") && ($oldcurhigh != "curhigh: 0") } {
if {$oldcurlist != $repl} {
poststuff privmsg ""
}}
if {($tellsongs == 1) && ($oldsong != $cursong) && ($streamstatus == "envivo: 1") } {
if {$songurl != ""} { set songurl " ($songurl)"}
regsub -all "&#x3C;" $cursong "<" cursong
regsub -all "&#x3E;" $cursong ">" cursong
regsub -all "&#x26;" $cursong "+" cursong
regsub -all "&#x22;" $cursong "\"" cursong
regsub -all "&#x27;" $cursong "'" cursong
regsub -all "&#xFF;" $cursong "" cursong
regsub -all "&#xB4;" $cursong "´" cursong
regsub -all "&#x96;" $cursong "-" cursong
regsub -all "&#xF6;" $cursong "ö" cursong
regsub -all "&#xE4;" $cursong "ä" cursong
regsub -all "&#xFC;" $cursong "ü" cursong
regsub -all "&#xD6;" $cursong "Ö" cursong
regsub -all "&#xC4;" $cursong "Ä" cursong
regsub -all "&#xDC;" $cursong "Ü" cursong
regsub -all "&#xDF;" $cursong "ß" cursong
regsub -all "&#xC1;" $cursong "Á" cursong 
regsub -all "&#xC9;" $cursong "É" cursong 
regsub -all "&#xCD;" $cursong "Í" cursong 
regsub -all "&#xD3;" $cursong "Ó" cursong 
regsub -all "&#xDA;" $cursong "Ú" cursong 
regsub -all "&#xE1;" $cursong "á" cursong 
regsub -all "&#xE9;" $cursong "é" cursong 
regsub -all "&#xED;" $cursong "í" cursong 
regsub -all "&#xF3;" $cursong "ó" cursong 
regsub -all "&#xFA;" $cursong "ú" cursong
regsub -all "&#xF1;" $cursong "ñ" cursong

putlog $cursong

set temp [open "dj" r]
set dj [gets $temp]
close $temp

set temp [open "peticiones" r]
set peticiones [gets $temp]
close $temp

set temp [open "ciudad" r]
set ciudad [gets $temp]
close $temp

#poststuff privmsg "1Quieres Escuchar La Radio IRC Haz Doble Click en ->> 12 http://radioirc.sytes.net:8000/listen.pls  En Linea 6$dj...La Actual Canción es: 4 [lrange $cursong 1 [llength $cursong]] .. Para Ver Comandos de la Radio Teclea 6!radio "
#poststuff privmsg "\002\0032En Cabina: \003Nuestro Locutor ¦ \0034$dj\003 ¦¤ Desde ¤¦ \0034$ciudad\003 ¦¤ \0032Escuchanos por \003https://radio-boom.wixsite.com/boom \0032- Peticiones \0034$peticiones\0032 Sonando:\00310 [lrange $cursong 1 [llength $cursong]] "

}

}}

putlog "-= Cargado: shoutcast.tcl Por *#Ayuda-eggdrop* =-"
