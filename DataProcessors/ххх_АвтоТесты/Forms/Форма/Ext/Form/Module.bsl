﻿
&НаКлиенте
Процедура ПолучитьОстатки(Команда)
	ПолучитьОстаткиНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьОстаткиНаСервере()
	ххх_РегламентныеЗадания.ххх_ЗапросОстатковЕГАИС();
КонецПроцедуры

&НаКлиенте
Процедура ПровестиАвтоТесты(Команда)
	ПровестиАвтоТестыНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПровестиАвтоТестыНаСервере()
	ххх_РегламентныеЗадания.ххх_АвтоТесты();
КонецПроцедуры

&НаКлиенте
Процедура ПереброситьПивоНа2Регистр(Команда)
	 ПереброситьПивоНа2РегистрСервер();
КонецПроцедуры


Процедура ПереброситьПивоНа2РегистрСервер()
	ххх_РегламентныеЗадания.ххх_ПередатьВТоргЗалПивасЕГАИС();
КонецПроцедуры


&НаКлиенте
Процедура СписатьПивоСо2Регистра(Команда)
	СписатьПивоСо2РегистраСервер();
КонецПроцедуры


Процедура СписатьПивоСо2РегистраСервер()
	ххх_РегламентныеЗадания.ххх_СписатьОстаткиВЕГАИСПвасаДоУчетных();
КонецПроцедуры
