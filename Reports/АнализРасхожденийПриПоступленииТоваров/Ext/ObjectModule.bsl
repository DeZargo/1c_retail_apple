﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПолеПоступлениеТоваров = Новый ПолеКомпоновкиДанных("ПоступлениеТоваров");
	
	ПараметрПоступлениеТоваров = КомпоновщикНастроек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ПолеПоступлениеТоваров);
	
	Если ПараметрПоступлениеТоваров <> Неопределено И ЗначениеЗаполнено(ПараметрПоступлениеТоваров.Значение) Тогда
		ОбщегоНазначенияРТ.ВывестиОснованиеОтчета(ДокументРезультат, ПараметрПоступлениеТоваров.Значение);
	Иначе
		ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
