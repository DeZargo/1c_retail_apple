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
Процедура ВыплачиватьЗарплатуВМагазинахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаРасходованиеДСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКассовуюКнигуПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаПоМагазинамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПередачиТоваровМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАгентскиеПлатежиИРазделениеВыручкиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьПремииВМагазинахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКомментарийНесколькоОрганизацийНажатие(Элемент)
	
	ТекстСообщения = Элемент.Подсказка;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКомментарийЗаявкиНаРасходованиеДСНажатие(Элемент)
	
	ТекстСообщения = Элемент.Подсказка;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ИспользоватьМониторПоказателейМагазинаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокОрганизаций(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Справочник.Организации.Форма.ФормаСписка.Открытие");
                 
	ОткрытьФорму("Справочник.Организации.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
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

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
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
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.Получить();
	
	Если НЕ ИспользоватьСинхронизациюДанных Тогда
		ТекстПодсказки = НСтр("ru = 'Невозможно включение заявок на расходование ДС, потому что:
		|- выключен обмен данными в разделе «Синхронизация данных»
		|- нет действующих обменов с УТ.'");
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Подсказка = ТекстПодсказки;
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Истина;
		
	ИначеЕсли ИспользоватьСинхронизациюДанных И НЕ НаборКонстант.ИспользуетсяОбменСУправлениемТорговлей Тогда
		
		ТекстПодсказки = НСтр("ru = 'Невозможно включение заявок на расходование ДС, потому что:
		|- нет действующих обменов с УТ.'");
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Подсказка = ТекстПодсказки;
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Истина;
	Иначе
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ИспользоватьЗаявкиНаРасходованиеДС.Доступность = ИспользоватьСинхронизациюДанных И НаборКонстант.ИспользуетсяОбменСУправлениемТорговлей;
	
	Элементы.ДекорацияКомментарийНесколькоОрганизаций.Видимость = Ложь;
	
	Элементы.КассоваяКнигаПоМагазинам.ТолькоПросмотр = НЕ НаборКонстант.ИспользоватьКассовуюКнигу;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		Если ИспользоватьСинхронизациюДанных Тогда
			Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоМагазину") <> Неопределено
				И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
				
				Элементы.РассчитыватьПремииВМагазинах.ТолькоПросмотр			= Истина;
				Элементы.ВыплачиватьЗарплатуВМагазинах.ТолькоПросмотр 			= Истина;
			ИначеЕсли ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоРабочемуМесту") <> Неопределено
				И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
				
				Элементы.ВыплачиватьЗарплатуВМагазинах.ТолькоПросмотр 			= Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		Элементы.ИспользоватьНесколькоОрганизаций.ТолькоПросмотр = Истина;
		Элементы.ИспользоватьНесколькоОрганизаций.Доступность    = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
