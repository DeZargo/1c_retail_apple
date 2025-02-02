﻿// Форма параметризуется:
//
//      ИдентификаторНаселенногоПункта    - УникальныйИдентификатор - Идентификатор текущего объекта для определения и
//                                                                    редактирования частей формы.
//      НаселенныйПунктДетально           - Структура               - Описание населенного пункта в терминах варианта
//                                                                    классификатора. Используется, если не указан
//                                                                    идентификатор.
//      ФорматАдреса - Строка - Вариант адресного  классификатора,
//      СкрыватьНеактуальныеАдреса        - Булево - Флаг того, что при редактировании неактуальные адреса будут
//                                                   скрываться.
//      СервисКлассификатораНедоступен    - Булево - Необязательный флаг того, что поставщик на обслуживании.
//
//  Результат выбора:
//      Структура - поля:
//          * Идентификатор           - УникальныйИдентификатор - Выбранный населенный пункт.
//          * Представление           - Строка                  - Представление выбранного.
//          * НаселенныйПунктДетально - Структура               - Отредактированное описание населенного пункта.
//
// -------------------------------------------------------------------------------------------------

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ФорматАдреса", ФорматАдреса);
	Параметры.Свойство("СервисКлассификатораНедоступен", СервисКлассификатораНедоступен);
	Параметры.Свойство("СкрыватьНеактуальныеАдреса ", СкрыватьНеактуальныеАдреса);
	
	Если ПустаяСтрока(ФорматАдреса) Тогда
		ФорматАдреса = "ФИАС";
	КонецЕсли;
	
	МожноЗагружатьКлассификатор = УправлениеКонтактнойИнформациейСлужебный.ЕстьВозможностьИзмененияАдресногоКлассификатора();
	ПрефиксИмениЧастиАдреса = "Часть";
	ЧастиАдреса = Параметры.НаселенныйПунктДетально;
	Если ЧастиАдреса = Неопределено Или ЧастиАдреса.Количество() = 0 Тогда
		ЧастиАдреса = УправлениеКонтактнойИнформациейСлужебный.СписокРеквизитовНаселенныйПункт( , ФорматАдреса);
	КонецЕсли;
	
	Если СервисКлассификатораНедоступен Тогда
		УправлениеКонтактнойИнформациейСлужебный.ЗаполнитьИдентификаторыНаселенногоПункта(ЧастиАдреса);
	КонецЕсли;
	
	ПостроитьФормуПоЧастямАдреса();
	УстановитьКлючИспользованияФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	
	Если АдресИзменен Тогда
		Результат = РезультатВыбора();
		
#Если ВебКлиент Тогда
		ФлагЗакрытия = ЗакрыватьПриВыборе;
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Результат);
		ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
		ОповеститьОВыборе(Результат);
#КонецЕсли
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПостроитьФормуПоЧастямАдреса()
	Добавлять = Новый Массив;
	
	ТипСтрока = Новый ОписаниеТипов("Строка");
	Для Каждого КлючЗначение Из ЧастиАдреса Цикл
		Часть = КлючЗначение.Значение;
		Имя   = КлючЗначение.Ключ;
		Добавлять.Добавить( Новый РеквизитФормы(ПрефиксИмениЧастиАдреса + Имя, ТипСтрока, , Часть.Заголовок));
	КонецЦикла;
	ИзменитьРеквизиты(Добавлять);
	РодительЭлементов = Элементы.ГруппаЧастейАдреса;
	ЭлементыФормыПоУровням.Очистить();
	
	Для Каждого КлючЗначение Из ЧастиАдреса Цикл
		Часть = КлючЗначение.Значение;
		Имя   = КлючЗначение.Ключ;
		
		Если Часть.Уровень < 7 И НЕ (ФорматАдреса = "КЛАДР" И (Часть.Уровень = 2 ИЛИ Часть.Уровень = 5))Тогда
			Элемент = Элементы.Добавить(ПрефиксИмениЧастиАдреса + Имя, Тип("ПолеФормы"), РодительЭлементов);
			
			Элемент.ПутьКДанным  = Элемент.Имя;
			Элемент.Вид          = ВидПоляФормы.ПолеВвода;
			
			Элемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.ПриИзмененииЗначения;
			
			Часть.Свойство("Подсказка", Элемент.Подсказка);
			Если ПустаяСтрока(Элемент.Подсказка) Тогда
				Элемент.Подсказка = Часть.Заголовок;
			КонецЕсли;
			
			Элемент.УстановитьДействие("ПриИзменении",         "Подключаемый_ПолеПриИзменении");
			Элемент.УстановитьДействие("ОкончаниеВводаТекста", "Подключаемый_ПолеОкончаниеВводаТекста");
			
			Если НЕ СервисКлассификатораНедоступен Тогда
				Элемент.КнопкаВыбора = Истина;
				Элемент.УстановитьДействие("НачалоВыбора",         "Подключаемый_ПолеНачалоВыбора");
				Элемент.УстановитьДействие("Очистка",              "Подключаемый_Очистка");
				Элемент.УстановитьДействие("ОбработкаВыбора",      "Подключаемый_ПолеОбработкаВыбора");
				Элемент.УстановитьДействие("Автоподбор",           "Подключаемый_ПолеАвтоподбор");
			КонецЕсли;
			ЭтотОбъект[Элемент.Имя] = Часть.Представление;
			ЭлементыФормыПоУровням.Добавить(КлючЗначение.Значение.Уровень, Элемент.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// -------------------------------------------------------------------------------------------------

&НаКлиенте 
Функция ИмяЧастиАдресаЭлемента(Элемент)
	
	Возврат Сред(Элемент.Имя, 1 + СтрДлина(ПрефиксИмениЧастиАдреса));
	
КонецФункции

&НаКлиенте 
Функция ЧастьАдресаЭлемента(Элемент)
	
	Возврат ЧастиАдреса[ИмяЧастиАдресаЭлемента(Элемент)];
	
КонецФункции

// -------------------------------------------------------------------------------------------------

&НаКлиенте
Функция УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение)
	
	Результат = УправлениеКонтактнойИнформациейКлиентСервер.УстановитьЗначениеЧастиАдреса(
		ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, ВыбранноеЗначение);
	
	ЭтотОбъект[Элемент.Имя] = Результат;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПолеПриИзменении(Элемент)
	АдресИзменен = Истина;
	
	ДоступностьКнопкиОК = Ложь;
	Для каждого Элемент Из ЭлементыФормыПоУровням Цикл
		Если НЕ ПустаяСтрока(ЭтотОбъект[Элемент.Представление]) Тогда
			ДоступностьКнопкиОК = Истина;
		КонецЕсли;
	КонецЦикла;
	Элементы.ФормаКомандаОК.Доступность = ДоступностьКнопкиОК;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	// Если пришли впрямую после редактирования, то сбрасываем значение части адреса.
	Если Элемент.ТекстРедактирования <> ЭтотОбъект[Элемент.Имя] Тогда
		УстановитьЗначениеЧастиАдреса(Элемент, Элемент.ТекстРедактирования);
	КонецЕсли;
	
	ЧастьАдреса = ЧастьАдресаЭлемента(Элемент);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыОткрытия.Вставить("СкрыватьНеактуальныеАдреса",        СкрыватьНеактуальныеАдреса);
	
	ПараметрыОткрытия.Вставить("Уровень",  ЧастьАдреса.Уровень);
	ПараметрыОткрытия.Вставить("Родитель", ИдентификаторРодителяЧастиАдресаЭлемента(ЧастьАдреса, ЧастиАдреса));
	
	// Текущий элемент
	ПараметрыОткрытия.Вставить("Идентификатор", ЧастьАдреса.Идентификатор);
	Представление = ?(ПустаяСтрока(ЧастьАдреса.Представление),ЧастьАдреса.Заголовок, ЧастьАдреса.Представление);
	ПараметрыОткрытия.Вставить("Представление", Представление);
	
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Очистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьДочерниеПоляАдреса(Элемент.Имя);
	АдресИзменен = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	
	Если ТипВыбранного = Тип("Структура") Тогда
		// Выбрано или кнопкой или из автоподбора.
		ВыбранноеЗначение.Свойство("Отказ", СервисКлассификатораНедоступен);
		
		Если СервисКлассификатораНедоступен Тогда
			СтандартнаяОбработка = Ложь;
			Если НЕ ПустаяСтрока(ВыбранноеЗначение.КраткоеПредставлениеОшибки) Тогда
				ПоказатьПредупреждение(, ВыбранноеЗначение.КраткоеПредставлениеОшибки);
			КонецЕсли;
			Возврат;
		Иначе
			НеЗагружатьАдресныйКлассификатор = ПараметрыПриложения.Получить("АдресныйКлассификатор.НеЗагружатьКлассификатор");
			Если НеЗагружатьАдресныйКлассификатор = Неопределено ИЛИ НеЗагружатьАдресныйКлассификатор = Ложь Тогда 
				РегионНеЗагружен = ВыбранноеЗначение.Свойство("РегионЗагружен") И ВыбранноеЗначение.РегионЗагружен = Ложь;
				Если МожноЗагружатьКлассификатор И РегионНеЗагружен Тогда
					// Предлагаем загрузить классификатор.
					УправлениеКонтактнойИнформациейКлиент.ПредложениеЗагрузкиКлассификатора(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Данные для ""%1"" не загружены.'"), ВыбранноеЗначение.Представление),
						ВыбранноеЗначение.Представление);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ОчиститьДочерниеПоляАдреса(Элемент.Имя);
		// Преобразуем выбранное в строку.
		ВыбранноеЗначение = УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение);
		АдресИзменен = Истина;
		ОбновитьОтображениеДанных();
		
	ИначеЕсли ТипВыбранного = Тип("Строка") Тогда
		УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение);
		АдресИзменен = Истина;
		ОбновитьОтображениеДанных();
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДочерниеПоляАдреса(ИмяЭлемента)
	
	УровеньВыбранногоПоля = 0;
	Для каждого Элемент Из ЭлементыФормыПоУровням Цикл
		Если Элемент.Представление = ИмяЭлемента Тогда
			УровеньВыбранногоПоля = Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если УровеньВыбранногоПоля = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если УровеньВыбранногоПоля < 6 Тогда
		Элемент = ЭлементыФормыПоУровням.НайтиПоЗначению(6);
		Если Элемент <> Неопределено Тогда 
			ЭтотОбъект[Элемент.Представление] = "";
			ОчиститьЧастьАдреса("НаселенныйПункт");
		КонецЕсли;
	КонецЕсли;
	
	Если УровеньВыбранногоПоля < 5 Тогда
		Элемент = ЭлементыФормыПоУровням.НайтиПоЗначению(5);
		Если Элемент <> Неопределено Тогда 
			ЭтотОбъект[Элемент.Представление] = "";
			ОчиститьЧастьАдреса("ВнутригРайон");
		КонецЕсли;
	КонецЕсли;
	
	Если УровеньВыбранногоПоля < 4 Тогда
		Элемент = ЭлементыФормыПоУровням.НайтиПоЗначению(4);
		Если Элемент <> Неопределено Тогда
			ЭтотОбъект[Элемент.Представление] = "";
			ОчиститьЧастьАдреса("Город");
		КонецЕсли;
	КонецЕсли;
	
	Если УровеньВыбранногоПоля < 3 Тогда
		Элемент = ЭлементыФормыПоУровням.НайтиПоЗначению(3);
		Если Элемент <> Неопределено Тогда 
			ЭтотОбъект[Элемент.Представление] = "";
			ОчиститьЧастьАдреса("Район");
		КонецЕсли;
	КонецЕсли;
	
	Если УровеньВыбранногоПоля < 2 Тогда
		Элемент = ЭлементыФормыПоУровням.НайтиПоЗначению(2);
		Если Элемент <> Неопределено Тогда 
			ЭтотОбъект[Элемент.Представление] = "";
			ОчиститьЧастьАдреса("Округ");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЧастьАдреса(ИмяЧасти)
		ЧастиАдреса[ИмяЧасти].Наименование = Неопределено;
		ЧастиАдреса[ИмяЧасти].Идентификатор = Неопределено;
		ЧастиАдреса[ИмяЧасти].Представление = Неопределено;
		ЧастиАдреса[ИмяЧасти].Сокращение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Ожидание = 0 Тогда
		// Формирование списка быстрого выбора, стандартную обработку не надо трогать.
		Возврат;
	КонецЕсли;
	
	Если СервисКлассификатораНедоступен Или СтрДлина(Текст) < 3 Тогда 
		// Нет вариантов, список пуст, стандартную обработку не надо трогать.
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ФорматАдреса", ФорматАдреса);
	ДополнительныеПараметры.Вставить("СкрыватьНеактуальные",              СкрыватьНеактуальныеАдреса);
	
	ДанныеКлассификатора = СписокАвтоподбораЧастиАдреса(Текст, ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, ДополнительныеПараметры);
	
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис поломался
		СервисКлассификатораНедоступен = Истина;
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ДанныеКлассификатора.Данные;
	
	// Стандартную обработку отключаем, только если есть наши варианты.
	Если ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресИзменен = Истина;
	УстановитьЗначениеЧастиАдреса(Элемент, Текст);
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	Результат = Новый Структура;
	
	Идентификатор = Неопределено;
	УправлениеКонтактнойИнформациейСлужебный.ЗаполнитьИдентификаторыНаселенногоПункта(ЧастиАдреса);
	Идентификатор = УправлениеКонтактнойИнформациейКлиентСервер.ИдентификаторЭлементаПоЧастямАдреса(ЧастиАдреса, Ложь);
	
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("Представление", УправлениеКонтактнойИнформациейКлиентСервер.ПредставлениеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса));
	Результат.Вставить("НаселенныйПунктДетально", ЧастиАдреса);
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция СписокАвтоподбораЧастиАдреса(Текст, ИмяЧастиАдреса, ЧастиАдреса, ДополнительныеПараметры)
	
	Возврат УправлениеКонтактнойИнформациейСлужебный.СписокАвтоподбораЧастиАдреса(Текст, ИмяЧастиАдреса, ЧастиАдреса, ДополнительныеПараметры);
	
КонецФункции

&НаСервере
Процедура УстановитьКлючИспользованияФормы()
	
	КлючСохраненияПоложенияОкна = СокрЛП(ФорматАдреса)
		+ "/" + Формат(ЧастиАдреса.Количество(), "ЧН=; ЧГ=");
		
КонецПроцедуры

&НаСервере
Функция ИдентификаторРодителяЧастиАдресаЭлемента(ЧастьАдреса, ЧастиАдреса)
	
	Идентификатор = Неопределено;
	ЕстьЧастьАдресаБезИдентификатора = ЕстьЛиИдентификаторРодителяЧастиАдресаЭлемента(ЧастиАдреса, ЧастьАдреса, Идентификатор);
	
	Если ЕстьЧастьАдресаБезИдентификатора Тогда
		УправлениеКонтактнойИнформациейСлужебный.ЗаполнитьИдентификаторыНаселенногоПункта(ЧастиАдреса);
		ЕстьЧастьАдресаБезИдентификатора = ЕстьЛиИдентификаторРодителяЧастиАдресаЭлемента(ЧастиАдреса, ЧастьАдреса, Идентификатор);
		Если ЕстьЧастьАдресаБезИдентификатора Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;

	Возврат Идентификатор;

КонецФункции

&НаСервере
Функция ЕстьЛиИдентификаторРодителяЧастиАдресаЭлемента(ЧастиАдреса, ЧастьАдреса, Идентификатор)
	
	ЕстьЧастьАдресаБезИдентификатора = Ложь;
	ЧастиАдресаВышеПоУровню = Новый Структура;
	УровеньАдреса = 0;
	Для Каждого КлючЗначение Из ЧастиАдреса Цикл
		Часть = КлючЗначение.Значение;
		Если Часть.Уровень < ЧастьАдреса.Уровень И НЕ ПустаяСтрока(Часть.Представление) Тогда
			ЧастиАдресаВышеПоУровню.Вставить(КлючЗначение.Ключ, Часть);
			Если ЗначениеЗаполнено(КлючЗначение.Значение.Идентификатор) Тогда
				Если УровеньАдреса < КлючЗначение.Значение.Уровень Тогда
					Идентификатор = КлючЗначение.Значение.Идентификатор;
					УровеньАдреса = КлючЗначение.Значение.Уровень;
				КонецЕсли;
			Иначе
				ЕстьЧастьАдресаБезИдентификатора = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат ЕстьЧастьАдресаБезИдентификатора;
КонецФункции

#КонецОбласти
