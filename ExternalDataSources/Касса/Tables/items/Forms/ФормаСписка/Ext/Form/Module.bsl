﻿
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	КассаПриИзмененииСервер()
КонецПроцедуры


Процедура КассаПриИзмененииСервер()
	Если ЗначениеЗаполнено(касса) Тогда
		пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		пСоед.СтрокаСоединения = Касса.ххх_СтрокаСоединения;//"DRIVER={MySQL ODBC 5.3 Ansi Driver};SERVER=192.168.0.247;PORT=3306;DATABASE=cassa;uid=operator;pwd=;";
		пСоед.АутентификацияОС=Ложь;
		пСоед.АутентификацияСтандартная=Истина;
		пСоед.ИмяПользователя=Касса.ххх_ИмяПользователяКассы;//"operator";
		пСоед.СУБД=Касса.ххх_ТипСубд;//"MySQL";
		ВнешниеИсточникиДанных.Касса.УстановитьОбщиеПараметрыСоединения(пСоед);
		//ВнешниеИсточникиДанных.Касса.ПолучитьПараметрыСоединенияСеанса();
		ВнешниеИсточникиДанных.Касса.УстановитьПараметрыСоединенияПользователя("Админ",пСоед);
		ВнешниеИсточникиДанных.Касса.УстановитьСоединение();
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	выборка=Справочники.КассыККМ.Выбрать();
	Если выборка.Следующий() Тогда
		Касса=выборка.Ссылка;
		пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		пСоед.СтрокаСоединения = выборка.ссылка.ххх_СтрокаСоединения;//"DRIVER={MySQL ODBC 5.3 Ansi Driver};SERVER=192.168.0.247;PORT=3306;DATABASE=cassa;uid=operator;pwd=;";
		пСоед.АутентификацияОС=Ложь;
		пСоед.АутентификацияСтандартная=Истина;
		пСоед.ИмяПользователя=выборка.ссылка.ххх_ИмяПользователяКассы;//"operator";
		пСоед.СУБД=выборка.ссылка.ххх_ТипСубд;//"MySQL";
		ВнешниеИсточникиДанных.Касса.УстановитьОбщиеПараметрыСоединения(пСоед);
		//ВнешниеИсточникиДанных.Касса.ПолучитьПараметрыСоединенияСеанса();
		ВнешниеИсточникиДанных.Касса.УстановитьПараметрыСоединенияПользователя("Админ",пСоед);
		ВнешниеИсточникиДанных.Касса.УстановитьСоединение();
	КонецЕсли;
КонецПроцедуры
