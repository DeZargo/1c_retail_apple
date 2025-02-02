﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		Если Номенклатура = СтрокаРезультата.Номенклатура Тогда
			Элементы.Список.ТекущаяСтрока = СтрокаРезультата.СерийныйНомер; 
		Иначе
			ТекстПредупреждения = НСтр("ru = 'По коду ""%1"" найден номер, принадлежащий другому сертификату.'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, СтруктураРезультат.ДанныеПО);
			СтруктураРезультат.Вставить("ТекстПредупреждения", ТекстПредупреждения);
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("ШтрихкодУпаковкиЕГАИС")
		И ЗначениеЗаполнено(СтрокаРезультата.ШтрихкодУпаковкиЕГАИС) Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиАкцизныхМарок(СтруктураРезультат, СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиНоменклатуры(СтруктураРезультат, СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Номенклатура = Параметры.Отбор.Владелец;
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("ТипСерийногоНомера", "ТипСерийногоНомера");
		СтруктураРеквизитов.Вставить("ИспользоватьСерийныеНомера", "ИспользоватьСерийныеНомера");
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
									Номенклатура,
									СтруктураРеквизитов);
		ТипСерийногоНомера = РеквизитыНоменклатуры.ТипСерийногоНомера;
		ИспользоватьСерийныеНомера = РеквизитыНоменклатуры.ИспользоватьСерийныеНомера;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ВыбиратьПовторноАктивированные") Тогда
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "ПовторноАктивирован", Ложь, Истина, ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПовторноАктивирован", "Видимость", Ложь);
	КонецЕсли;
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементамиФормыНаСервере()
			
	Если Номенклатура.Пустая() Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Не задан владелец - номенклатура номера подарочного сертификата'");
		АвтоЗаголовок = Ложь;
		Заголовок     = ТекстЗаголовка;
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.Владелец.Видимость = Истина;
		
	ИначеЕсли ИспользоватьСерийныеНомера Тогда
		
		Заголовок = "";
		АвтоЗаголовок = Истина;	
		Элементы.Список.ТолькоПросмотр = Ложь;
		Элементы.Владелец.Видимость = Ложь;
		
	Иначе	
		
		ТекстЗаголовка = НСтр("ru = 'Для элемента ""%Владелец%"" номера подарочных сертификатов не используются'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Номенклатура));
		АвтоЗаголовок = Ложь;
		Заголовок     = ТекстЗаголовка;
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.Владелец.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.Штрихкод.Видимость = ТипСерийногоНомера = Перечисления.ТипыСерийныхНомеровСертификатов.Смешанный;
	
КонецПроцедуры 

#КонецОбласти
