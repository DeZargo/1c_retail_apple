﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.БанковскийСчет.Доступность = ЗначениеЗаполнено(Объект.Организация);
		ПризнакАгентаИзменение();
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДоговораПриИзменении(Элемент)
	
	Объект.Посредник = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Элементы.БанковскийСчет.Доступность = ЗначениеЗаполнено(Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакАгентаПриИзменении(Элемент)
	
	ПризнакАгентаИзменение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакАгентаИзменение()
	
	ПризнакАгента = Объект.ПризнакАгента;
	
	ЭтоБанковскийПлатежныйАгент = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.БанковскийПлатежныйАгент");
	ЭтоПлатежныйАгент           = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.ПлатежныйАгент");
	ЭтоКомиссионер              = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.Комиссионер");
	
	Элементы.ТипДоговора.Доступность = НЕ ЭтоКомиссионер;
	Если ЭтоКомиссионер Тогда
		Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоровПлатежныхАгентов.Прямой");
		Объект.Посредник = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
	Элементы.СтраницаДополнительно.Видимость =  НЕ ЭтоКомиссионер;
	
	БанковскийПлатежныйАгент = ЭтоБанковскийПлатежныйАгент ИЛИ ЭтоПлатежныйАгент;
	
	Элементы.ГруппаПрочие.Доступность                  = БанковскийПлатежныйАгент;
	Элементы.АдресОператораПеревода.Доступность        = БанковскийПлатежныйАгент;
	Элементы.ТелефонОператораПеревода.Доступность      = БанковскийПлатежныйАгент;
	Элементы.ИННОператораПеревода.Доступность          = БанковскийПлатежныйАгент;
	Элементы.НаименованиеОператораПеревода.Доступность = БанковскийПлатежныйАгент;
	Элементы.ОперацияПлатежногоАгента.Доступность      = БанковскийПлатежныйАгент;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура АгентПриИзменении(Элемент)
	
	АгентПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаВознагражденияПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	ПризнакАгента = Объект.ПризнакАгента;
	
	ЭтоБанковскийПлатежныйАгент = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.БанковскийПлатежныйАгент");
	ЭтоПлатежныйАгент           = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.ПлатежныйАгент");
	ЭтоКомитент                 = ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.Комиссионер");
	
	
	Если Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоровПлатежныхАгентов.Субагентский") Тогда
		Элементы.Посредник.Видимость = Истина;
	Иначе
		Элементы.Посредник.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТипДоговора.Доступность = НЕ ЭтоКомитент;
	
	ДоступенРасчетВознаграждения = Объект.СпособРасчетаКомиссионногоВознаграждения = 
	ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается");
	
	Если Объект.ПризнакАгента = ПредопределенноеЗначение("Перечисление.ПризнакиАгента.Комиссионер") Тогда
		Элементы.ПроцентКомиссионногоВознаграждения.Доступность = Не ДоступенРасчетВознаграждения;
	Иначе
		Элементы.ПроцентКомиссионногоВознаграждения.Доступность = Истина;
	КонецЕсли;
	
	Если ДоступенРасчетВознаграждения Тогда
		Объект.ПроцентКомиссионногоВознаграждения = 0;
	КонецЕсли;
	
	ТекстЗаголовка = "Поставщик услуг";
	ТекстСтраницы  = "Вознаграждение";
	ТекстГруппы    = "";
	
	Если ЭтоКомитент Тогда
		ТекстЗаголовка = "Комитент"; 
		ТекстСтраницы  = "Комиссионная торговля";
		ТекстГруппы    = "Комиссионное вознаграждение";
	КонецЕсли;

	Элементы.ГруппаКомиссионноеВознаграждениеЛево.Видимость = ЭтоКомитент;
	Элементы.СтраницаВознаграждение.Заголовок               = ТекстСтраницы;
	Элементы.ГруппаКомиссионноеВознаграждение.Заголовок     = ТекстГруппы;
	Элементы.Агент.Заголовок                                = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура АгентПриИзмененииСервер()
	
	Объект.ИННПоставщикаУслуг = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Агент, "ИНН");
	
КонецПроцедуры

#КонецОбласти



