﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Перем ОбновитьИнтерфейс;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске.
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработчикОповещений(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьУчетСебестоимостиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СебестоимостьВключаетНДСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОрдернуюСхемуПриИзменении(Элемент)
	Если НЕ НаборКонстант.ИспользоватьОрдернуюСхему Тогда
		ТекстВопроса =
			НСтр("ru = 'Отключить использование ордерной схемы?
			           |
			           |Для всех магазинов будут сброшены флаги использования
					   |ордерной схемы документооборота.'");
					   
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьОрдернуюСхемуПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ОКОтмена);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПараметрыАнализаПересортицы(Команда)
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		Истина, "ОбщаяФорма.ПараметрыАнализаПересортицы.Открытие");
        
    ОткрытьФорму("ОбщаяФорма.ПараметрыАнализаПересортицы",,,,,,,Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУстановкиСебестоимости(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Документ.УстановкаСебестоимости.Форма.ФормаСписка.Открытие");

	ОткрытьФорму("Документ.УстановкаСебестоимости.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуСпособовУчетаСебестоимости(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.НастройкаСпособаУчетаСебестоимости.Форма.ФормаСписка.Открытие");

	ОткрытьФорму("РегистрСведений.НастройкаСпособаУчетаСебестоимости.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиВариантовРаспределения(Команда)
    
    // &ЗамерПроизводительности
     ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Справочник.ВариантыРаспределенияТоваров.Форма.ФормаСписка.Открытие");
        

	ОткрытьФорму("Справочник.ВариантыРаспределенияТоваров.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
			ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
			ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Обработка оповещений от других открытых форм.
//
// Пример:
//   Если ИмяСобытия = "НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы" Тогда
//     НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы = Параметр;
//   КонецЕсли;
//
&НаКлиенте
Процедура ОбработчикОповещений(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОрдернуюСхемуПриИзмененииЗавершение(Ответ, Элемент) Экспорт

	Если НЕ Ответ = КодВозвратаДиалога.ОК Тогда
		НаборКонстант.ИспользоватьОрдернуюСхему = Истина;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;

КонецПроцедуры
 

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	Результат = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Определение имени константы.
	КонстантаИмя = "";
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат КонстантаИмя;
	КонецЕсли;
	
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОрдернуюСхему" И НЕ НаборКонстант.ИспользоватьОрдернуюСхему Тогда
		Справочники.Магазины.ОтключитьИспользованиеОрдернойСхемы();
	КонецЕсли;	
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетСебестоимости" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.СебестоимостьВключаетНДС.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
		Элементы.ОткрытьУстановкиСебестоимости.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
		Элементы.ОткрытьНастройкуСпособовУчетаСебестоимости.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		Если НаборКонстант.ИспользоватьСинхронизациюДанных Тогда
			Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоМагазину") <> Неопределено
				И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
				
				Элементы.ИспользоватьУчетСебестоимости.ТолькоПросмотр 					= Истина;
				Элементы.СебестоимостьВключаетНДС.ТолькоПросмотр 						= Истина;
				
			ИначеЕсли ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоРабочемуМесту") <> Неопределено
				И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
				
				Элементы.ИспользоватьУчетСебестоимости.ТолькоПросмотр 					= Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



