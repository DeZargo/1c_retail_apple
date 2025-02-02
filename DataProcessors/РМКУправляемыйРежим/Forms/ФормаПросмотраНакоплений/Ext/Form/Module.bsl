﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ЗаголовокИнформации = НСтр("ru = 'При подключении оборудования произошла ошибка:'");
		ТекстИнформации     = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(ЗаголовокИнформации, ТекстИнформации);
	КонецЕсли;
	
КонецПроцедуры

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
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		Иначе
			ДисконтнаяКарта = СтрокаРезультата.Карта;
			ДисконтнаяКартаПриИзменении();
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиСертификатов(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("ШтрихкодУпаковкиЕГАИС")
		И ЗначениеЗаполнено(СтрокаРезультата.ШтрихкодУпаковкиЕГАИС) Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиАкцизныхМарок(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиНоменклатуры(СтруктураРезультат, СтрокаРезультата);
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКодуРМК(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОповещениеОткрытьФормуВводаЧисла(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	ТекКод = "";
	Если НЕ РезультатОткрытияФормы = Неопределено Тогда
		ЗначениеВыбораЧисло = РезультатОткрытияФормы.ВведенноеЧисло;
		Если ЗначениеЗаполнено(ЗначениеВыбораЧисло) Тогда
			ЧислоВвода = ЗначениеВыбораЧисло;
			ТекКод = Формат(ЗначениеВыбораЧисло, "ЧН=0; ЧГ=0");
			Если ДополнительныеПараметры.Свойство("ПолученМагнитныйКод") Тогда
				СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
			ИначеЕсли ДополнительныеПараметры.Свойство("ПолученШтрихкодИзСШК") Тогда
				СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(ТекКод);
			КонецЕсли;
			ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДисконтнойКарты(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если РезультатОткрытияФормы <> Неопределено Тогда
		ДисконтнаяКарта = РезультатОткрытияФормы.ДисконтнаяКарта;
		ДисконтнаяКартаПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВводКартДоступен") Тогда
		ВводКартДоступен = Параметры.ВводКартДоступен;
	Иначе
		ВводКартДоступен = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ВыборИнформационнойКартыТолькоПоКоду") Тогда
		ВыборИнформационнойКартыТолькоПоКоду = Параметры.ВыборИнформационнойКартыТолькоПоКоду;
	Иначе
		ВыборИнформационнойКартыТолькоПоКоду = Истина;
	КонецЕсли;
	
	
	Если Параметры.Свойство("РазрешитьПодборИнформационнойКарты") Тогда
		РазрешитьПодборИнформационнойКарты = Параметры.РазрешитьПодборИнформационнойКарты;
	Иначе
		РазрешитьПодборИнформационнойКарты = Истина;
	КонецЕсли;
	
	ИспользоватьБонусныеПрограммыЛояльности = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммыЛояльности");
	РеквизитыДокумента = Параметры.РеквизитыДокумента;
	ДисконтнаяКарта = РеквизитыДокумента.ДисконтнаяКарта;
	Если ЗначениеЗаполнено(ДисконтнаяКарта) Тогда
		ДисконтнаяКартаПриИзменении();
	Иначе
		Элементы.ДекорацияБезПрограммы.Заголовок = "";
		ОписаниеДисконтнойКарты = НСтр("ru = 'Считайте карту'");
		УстановитьВидимостьЭлементов();
	КонецЕсли;
	
	ЭтотОбъект.Заголовок = ОписаниеДисконтнойКарты;
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	ПараметрыСобытийПО = Новый Структура;
	ПараметрыСобытийПО.Вставить("РегистрацияНовойКарты", Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(ОповещенияПриПодключении, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
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
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудованияРМК(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ДополнительныеПараметры = Новый Структура("ПолученМагнитныйКод");
	ПолучитьИнтерактивноЧисло(НСтр("ru = 'Введите магнитный код'"), ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ДополнительныеПараметры = Новый Структура("ПолученШтрихкодИзСШК");
	ПолучитьИнтерактивноЧисло(НСтр("ru = 'Введите штрихкод'"), ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКарту(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Обработка.РМКУправляемыйРежим.Форма.ФормаВыбораДисконтнойКарты.Открытие");

	ОбработчикОповещения= Новый ОписаниеОповещения("ОповещениеОткрытьФормуВыбораДисконтнойКарты", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОткрытьФорму("Обработка.РМКУправляемыйРежим.Форма.ФормаВыбораДисконтнойКарты",,УникальныйИдентификатор,,,, ОбработчикОповещения, Режим);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДисконтнаяКартаПриИзменении() 
	
	РеквизитыДокумента.ДисконтнаяКарта = ДисконтнаяКарта;
	
	СуммаНакопления = СкидкиНаценкиСерверПереопределяемый.СуммаНакопленияПоКартеДляПечатиЧека(РеквизитыДокумента);
	КартаБонусная = Ложь;
	
	Если ИспользоватьБонусныеПрограммыЛояльности Тогда
		БонуснаяПрограммаЛояльности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДисконтнаяКарта, "БонуснаяПрограммаЛояльности");
		Если ЗначениеЗаполнено(БонуснаяПрограммаЛояльности) Тогда
			КартаБонусная = Истина;
			ОписаниеБонуснойПрограммы = Строка(БонуснаяПрограммаЛояльности);
			Если РеквизитыДокумента.СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Архивный Тогда
				ДатаЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.ОтчетОРозничныхПродажах, "Дата");
			Иначе
				Если РеквизитыДокумента.Ссылка.Пустая() Тогда
					ДатаЗапроса = ТекущаяДатаСеанса();
				Иначе
					ДатаЗапроса = РеквизитыДокумента.Дата;
				КонецЕсли;
			КонецЕсли;
			ОстаткиБонусныхБаллов.Загрузить(БонусныеБаллыСервер.ОстаткиИДвиженияБонусныхБаллов(ДисконтнаяКарта, ДатаЗапроса));
			Элементы.ДекорацияБезПрограммы.Заголовок = "";
		Иначе
			Элементы.ДекорацияБезПрограммы.Заголовок = НСтр("ru = 'Карта не участвует в бонусных программах лояльности'");
		КонецЕсли;
	Иначе
		Элементы.ДекорацияБезПрограммы.Заголовок = "";
	КонецЕсли;
	СтрокаОписанияДисконтнойКарты = НСтр("ru = 'Данные по карте %1'");
	ОписаниеДисконтнойКарты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОписанияДисконтнойКарты, ДисконтнаяКарта);
	ЭтотОбъект.Заголовок = ОписаниеДисконтнойКарты;
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Если КартаБонусная Тогда
		Элементы.СтраницаБонусы.Видимость = Истина;
		Элементы.СтраницаНетБонусов.Видимость = Ложь;
	Иначе
		Элементы.СтраницаБонусы.Видимость = Ложь;
		Элементы.СтраницаНетБонусов.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ВыбратьКарту.Видимость = (НЕ ВыборИнформационнойКартыТолькоПоКоду) И РазрешитьПодборИнформационнойКарты;
	Элементы.ГруппаКнопкиОборудования.Видимость = ВводКартДоступен;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИнтерактивноЧисло(Заголовок, ДополнительныеПараметры = Неопределено)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок"             , Заголовок);
	ПараметрыФормы.Вставить("МаксимальноеЗначение"  , 0);
	ПараметрыФормы.Вставить("ЧислоВвода"            , 0);
	ПараметрыФормы.Вставить("Отрицательное"         , Ложь);
	ПараметрыФормы.Вставить("ВозвращатьЧислоСтрокой", Истина);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуВводаЧисла", ЭтотОбъект, ДополнительныеПараметры);
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОткрытьФорму("Обработка.РМКУправляемыйРежим.Форма.ФормаВводаЧисла", ПараметрыФормы, УникальныйИдентификатор,,,, ОбработчикОповещения, Режим); 
	
КонецФункции 

#КонецОбласти
