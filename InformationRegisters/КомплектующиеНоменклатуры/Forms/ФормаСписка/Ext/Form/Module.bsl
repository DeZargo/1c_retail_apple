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
		
	Иначе
		
		Если ТекущийЭлемент = Элементы.ОтборНоменклатура Тогда
			Номенклатура = СтрокаРезультата.Номенклатура;
			Если СтрокаРезультата.Свойство("Характеристика") Тогда
				Характеристика = СтрокаРезультата.Характеристика;
			Иначе
				Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			КонецЕсли;
			УстановитьОтборДинамическогоСписка("Характеристика");
			УстановитьОтборДинамическогоСписка("Номенклатура");
			Элементы.ОтборХарактеристика.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Номенклатура);
		Иначе
			ОбщегоНазначенияРТКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Комплектующая", СтрокаРезультата.Номенклатура);
			
			Если СтрокаРезультата.Свойство("Характеристика")
				И ЗначениеЗаполнено(СтрокаРезультата.Характеристика) Тогда
				ОбщегоНазначенияРТКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "ХарактеристикаКомплектующей", СтрокаРезультата.Характеристика);
			Иначе
				ОбщегоНазначенияРТКлиентСервер.УдалитьЭлементОтбораСписка(Список, "ХарактеристикаКомплектующей");
			КонецЕсли;
			Если СтрокаРезультата.Свойство("Упаковка")
				И ЗначениеЗаполнено(СтрокаРезультата.Упаковка) Тогда
				ОбщегоНазначенияРТКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Упаковка", СтрокаРезультата.Упаковка);
			Иначе
				ОбщегоНазначенияРТКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Упаковка");
			КонецЕсли;
		КонецЕсли;

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

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Характеристика = Результат;
	ОтборХарактеристикаПриИзменении(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		
		Если  Параметры.Отбор.Свойство("Номенклатура") Тогда
			
			Номенклатура = Параметры.Отбор.Номенклатура;
			Если Номенклатура = Неопределено 
				ИЛИ Номенклатура.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Товар Тогда
				
				ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Номенклатура%"" комплектующие не задаются'");
				ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Номенклатура%", Строка(Номенклатура));
				АвтоЗаголовок = Ложь;
				Заголовок     = ТекстЗаголовка;
				Элементы.Список.ТолькоПросмотр = Истина;
				
			Иначе
				
				ТекстЗаголовка = НСтр("ru = 'Комплектующие (%Номенклатура%)'");
				ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Номенклатура%", Строка(Номенклатура));
				АвтоЗаголовок = Ложь;
				Заголовок     = ТекстЗаголовка;
			КонецЕсли;
			
		Элементы.БыстрыеОтборы.Видимость = Ложь;
		
		КонецЕсли;
				
	КонецЕсли;

	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.КомплектующиеНоменклатуры.Форма.ФормаСписка.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	УстановитьДоступностьХарактеристики();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Номенклатура   = Настройки.Получить("Номенклатура");
	Характеристика = Настройки.Получить("Характеристика");
	УстановитьОтборДинамическогоСписка("Номенклатура");
	УстановитьОтборДинамическогоСписка("Характеристика");
	
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

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.КомплектующиеНоменклатуры.Форма.ФормаЗаписи.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборНоменклатураПриИзменении(Элемент)
	
	ПриИзмененииОтборНоменклатура();
	УстановитьДоступностьХарактеристики();
КонецПроцедуры

&НаКлиенте
Процедура ОтборХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтборХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", Характеристика);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", 0);
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборХарактеристикаПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Характеристика");
	
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

&НаКлиенте
Процедура ОчиститьОтбор(Команда)
	
	ОбщегоНазначенияРТКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Комплектующая");
	ОбщегоНазначенияРТКлиентСервер.УдалитьЭлементОтбораСписка(Список, "ХарактеристикаКомплектующей");
	ОбщегоНазначенияРТКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Упаковка");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтотОбъект[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизита]));
		
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтборНоменклатура()
	
	РезультатПроверки = Справочники.Номенклатура.ПроверитьПринадлежностьХарактеристикиИУпаковкиВладельцу(Номенклатура, Характеристика, Неопределено);

	Характеристика = РезультатПроверки.Характеристика;
	УстановитьОтборДинамическогоСписка("Характеристика");
	УстановитьОтборДинамическогоСписка("Номенклатура");
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьХарактеристики()
	
	Элементы.ОтборХарактеристика.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Номенклатура);
	
КонецПроцедуры

#КонецОбласти
