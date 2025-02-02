﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора, Ложь);
		
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
		
		ИнтеграцияВЕТИСКлиентСервер.ОрганизацияВЕТИСОтборПриИзменении(ЭтотОбъект,"");
		
	ИначеЕсли Параметры.Отбор.Свойство("ХозяйствующийСубъект") 
		ИЛИ Параметры.Отбор.Свойство("Предприятие") Тогда
		
		Элементы.СтраницыОтборОрганизацияВЕТИС.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Продукция") Тогда
		ЗаполнитьРеквизитыПоПродукции(Параметры.Продукция);
		ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Элементы.ФормаВыбрать.Видимость = РежимВыбора;

	Если ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС) Тогда
		Элементы.ФормаОбъединитьЗаписиЖурнала.Видимость = НЕ РежимВыбора;
		Элементы.СписокКонтекстноеМенюОбъединитьЗаписиЖурнала.Видимость = НЕ РежимВыбора;
	Иначе
		Элементы.ФормаОбъединитьЗаписиЖурнала.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюОбъединитьЗаписиЖурнала.Видимость = Ложь;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПродукция();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписок_ОстаткиПродукцииВЕТИС" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОписаниеПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьВидПродукции" Тогда
		ОткрытьФормыВыбораВидаПродукции();
		Возврат;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОчиститьИерархию" Тогда
		ОчиститьИерархию();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоПродукции" Тогда
		ОчиститьВидПродукции();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоТипуПродукции" Тогда
		ОчиститьВидПродукцииПродукцию();
	КонецЕсли;
	
	ОбработатьИзменениеОтбораПопродукции();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ВидыПериодов = СтрРазделить("ДатаПроизводства,СрокГодности",",");
	
	Для каждого Строка Из Строки Цикл
		
		ДанныеСтроки = Строка.Значение.Данные;
		ОформлениеСтроки = Строка.Значение.Оформление;
		
		Для каждого ВидПериода Из ВидыПериодов Цикл
			Если ДанныеСтроки.Свойство(ВидПериода) Тогда
				
				ПредставлениеПериода = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(
					ДанныеСтроки[ВидПериода+"ТочностьЗаполнения"],
					ДанныеСтроки[ВидПериода+"НачалоПериода"],
					ДанныеСтроки[ВидПериода+"КонецПериода"],
					ДанныеСтроки[ВидПериода+"Строка"]);
					
				ОформлениеСтроки[ВидПериода].УстановитьЗначениеПараметра("Текст", ПредставлениеПериода);
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборЗаписиЖурнала();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработатьВыборЗаписиЖурнала();
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьЗаписиЖурнала(Команда)
	
	ВыбранныеЗаписи = ВыбранныеЗаписиСкладскогоЖурнала();
	
	Если ВыбранныеЗаписи.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ВыбранныеЗаписи);
		ОткрытьФорму("Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ФормаОбъекта", ПараметрыФормы);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВетеринарныеМероприятия(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ЗаписьСкладскогоЖурнала", ТекущиеДанные.ЗаписьСкладскогоЖурнала);
	
	ОткрытьФорму(
		"Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Форма.ВетеринарныеМероприятия",
		ПараметрыОткрытияФормы,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборЗаписиЖурнала()

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		ОповеститьОВыборе(ТекущиеДанные.ЗаписьСкладскогоЖурнала);
		
	Иначе
		
		ПоказатьЗначение(,ТекущиеДанные.ЗаписьСкладскогоЖурнала);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоПродукции(Продукция)
	
	РеквизитыПродукции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Продукция,
		"ТипПродукции,Продукция,ВидПродукции");
		
	Продукция    = РеквизитыПродукции.Продукция;
	ТипПродукции = РеквизитыПродукции.ТипПродукции;
	ВидПродукции = РеквизитыПродукции.ВидПродукции;
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеЗаписиСкладскогоЖурнала()

	ВыбранныеЗаписи = Новый Массив;
	
	Для каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		Если ТипЗнч(СтрокаСписка) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ВыбранныеЗаписи.Добавить(СтрокаСписка.ЗаписьСкладскогоЖурнала);
		КонецЕсли;
	КонецЦикла;

	Возврат ВыбранныеЗаписи;
	
КонецФункции
 
#Область ОтборПоПродукции

&НаКлиенте
Процедура ОбработатьИзменениеОтбораПопродукции()
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
	УстановитьОтборПродукция();
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформациюОВидеТипеПродукции(Форма)
	
	ЦветГиперссылки = Форма.ЦветГиперссылки;
	
	Если ЗначениеЗаполнено(Форма.ТипПродукции) Тогда
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			Строка(Форма.ТипПродукции),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОтборПоТипуПродукции");
		ОписаниеПродукцииПодсказка = Строка(Форма.ТипПродукции);
		
		ОписаниеПродукции = Новый ФорматированнаяСтрока(СтрокаСсылка);
		
		Если ЗначениеЗаполнено(Форма.Продукция) Тогда
			СтрокаПродукция = Строка(Форма.Продукция);
			ДлиннаяСтрока = СтрДлина(СтрокаПродукция)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаПродукция,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""));
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаПродукция;
		КонецЕсли;
		Если ЗначениеЗаполнено(Форма.ВидПродукции) Тогда
			СтрокаВидПродукции = Строка(Форма.ВидПродукции);
			ДлиннаяСтрока = СтрДлина(СтрокаВидПродукции)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаВидПродукции,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоВидуПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""), " ");
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаВидПродукции;
		КонецЕсли;
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru='изменить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " ", "(", СтрокаСсылка, " ", НСтр("ru='или'"), " ");
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru='очистить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОчиститьИерархию");
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, СтрокаСсылка, ")");
	Иначе
		
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(
			НСтр("ru='Выбрать группу продукции'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		
	КонецЕсли;
	
	Форма.Элементы.ОписаниеПродукции.Подсказка = ОписаниеПродукцииПодсказка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормыВыбораВидаПродукции()
	ОткрытьФорму("Обработка.КлассификаторыВЕТИС.Форма.КлассификаторИерархииПродукции",,ЭтаФорма,,,,
		Новый ОписаниеОповещения("КлассификаторПродукцииПриЗавершенииВыбора",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПродукцииПриЗавершенииВыбора(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ПолучитьИерархиюПродукции(Результат);
	КонецЕсли;
	УстановитьОтборПродукция();
КонецПроцедуры

&НаСервере
Процедура ПолучитьИерархиюПродукции(ВыбраннаяПродукция)
	
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыбраннаяПродукция, "ТипПродукции, Продукция");
	Если ЗначениеЗаполнено(Результат.Продукция) Тогда
		ВидПродукции = ВыбраннаяПродукция;
		Продукция    = Результат.Продукция;
		ТипПродукции = Результат.ТипПродукции;
	ИначеЕсли ЗначениеЗаполнено(Результат.ТипПродукции) Тогда
		ВидПродукции = Неопределено;
		Продукция    = ВыбраннаяПродукция;
		ТипПродукции = Результат.ТипПродукции;
	Иначе
		ВидПродукции = Неопределено;
		Продукция    = Неопределено;
		ТипПродукции = ВыбраннаяПродукция;
	КонецЕсли;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИерархию()
	
	ВидПродукции     = Неопределено;
	Продукция        = Неопределено;
	ТипПродукции     = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукции()
	
	ВидПродукции     = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукцииПродукцию()
	
	ВидПродукции     = Неопределено;
	Продукция        = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПродукция()
	
	ПродукцияОтбор = Неопределено;
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ПродукцияОтбор = ВидПродукции;
	ИначеЕсли ЗначениеЗаполнено(Продукция) Тогда
		ПродукцияОтбор = Продукция;
	ИначеЕсли ЗначениеЗаполнено(ТипПродукции) Тогда
		ПродукцияОтбор = ТипПродукции;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма.Список,
		"Продукция",
		ПродукцияОтбор,
		ВидСравненияКомпоновкиДанных.ВИерархии,,
		ЗначениеЗаполнено(ПродукцияОтбор));
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти