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
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ДобавитьНайденныеСерийныеНомера(СтрокаРезультата);
		
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
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьДанныеИзТСДСервер(СтруктураПараметров) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТВызовСервера.ОбработатьДанныеПоСертификатамИзТСДСервер(ЭтотОбъект, СтруктураПараметров);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеСерийныеНомера(СтруктураНомера) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	
	СтрокиССерийнымНомером = ПогашениеПодарочныхСертификатов.НайтиСтроки(Новый Структура("СерийныйНомер", СтруктураНомера.СерийныйНомер));
	
	Если СтрокиССерийнымНомером.Количество() > 0 Тогда
		СтрокаОшибки = НСтр("ru = 'Номер подарочного сертификата уже выбран в документе'");
		ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		
		ИдентификаторСтроки = СтрокиССерийнымНомером[0].ПолучитьИдентификатор();
		
	Иначе
		СтрокаПогашения = ПогашениеПодарочныхСертификатов.Добавить();
		СтрокаПогашения.ПодарочныйСертификат = СтруктураНомера.Номенклатура;
		СтрокаПогашения.СерийныйНомер = СтруктураНомера.СерийныйНомер;
		СтрокаПогашения.Номинал = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаПогашения.ПодарочныйСертификат, "Номинал");
		СтрокаПогашения.ИспользоватьСерийныеНомера = Истина;
		
		ИдентификаторСтроки = СтрокаПогашения.ПолучитьИдентификатор();
		
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораСерийногоНомера(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	Если НЕ РезультатОткрытияФормы = Неопределено 
		 И ТипЗнч(РезультатОткрытияФормы) = Тип("Структура") Тогда
		
		СтрокаТаблицы = ПогашениеПодарочныхСертификатов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатОткрытияФормы);
		ЧастьКода = "";
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем АдресВременногоХранилища;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("АдресВременногоХранилища_ПогашениеПодарочныхСертификатов",АдресВременногоХранилища) Тогда
	
		Отказ = Истина;
		Текст = НСтр("ru = 'Данная форма может быть открыта только с переданными данными чека'"); 
		ОбщегоНазначения.СообщитьПользователю(Текст);
		Возврат;
	
	КонецЕсли;
	
	Таблица_ПогашениеПодарочныхСертификатов = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗаполнитьТаблицуЗначенийПогашение(Таблица_ПогашениеПодарочныхСертификатов);
	
	МассивКомандПО = Новый Массив;
	МассивКомандПО.Добавить("ПогашениеПодарочныхСертификатовЗагрузитьДанныеИзТСД");
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект, МассивКомандПО);
	
	УстановитьВидимостьНомеровСертификатов();
	
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

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЧастьКодаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, Ложь)
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастьКодаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, Истина)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПогашениеПодарочныхСертификатов

&НаКлиенте
Процедура ПогашениеПодарочныхСертификатовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		ТекущаяСтрока = Элементы.ПогашениеПодарочныхСертификатов.ТекущиеДанные;
		ТекущаяСтрока.СерийныйНомер = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеПодарочныхСертификатовПодарочныйСертификатПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПогашениеПодарочныхСертификатов.ТекущиеДанные;
	ЗаполнитьДанныеСтрокиСервер(ТекущаяСтрока.ПодарочныйСертификат, ТекущаяСтрока.Номинал, ТекущаяСтрока.ИспользоватьСерийныеНомера);
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеПодарочныхСертификатовСерийныйНомерПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПогашениеПодарочныхСертификатов.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.СерийныйНомер) Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("СерийныйНомер", ТекущаяСтрока.СерийныйНомер);
		
		СтрокиТаблицы = ПогашениеПодарочныхСертификатов.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиТаблицы.Количество() > 1 Тогда
		
			ТекущаяСтрока.СерийныйНомер = "";
			
			ТекстСообщения = НСтр("ru = 'Номер подарочного сертификата уже был указан в документе!'"); 
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ЕстьОшибки = Ложь;
	ОчиститьСообщения();
	ПроверитьЗаполнениеФормы(ЕстьОшибки);
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	АдресХранилища = ПоместитьПогашениеВХранилище();
	Закрыть(АдресХранилища);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяТаблицыВыборки", "ПогашениеПодарочныхСертификатов");
	ДополнительныеПараметры.Вставить("ЕстьКоличество", Ложь);
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьПогашениеВХранилище()

	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПогашениеПодарочныхСертификатов.Выгрузить());
	
	Возврат АдресВоВременномХранилище;

КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеСтрокиСервер(ПодарочныйСертификат, Номинал, ИспользоватьСерийныеНомера);

	Номинал = ПодарочныйСертификат.Номинал;
	ИспользоватьСерийныеНомера = ПодарочныйСертификат.ИспользоватьСерийныеНомера

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, ВыводитьСообщения)

	Если ЗначениеЗаполнено(Текст)  Тогда
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ЭтоРеализация"                    , Ложь);
		СтруктураПараметров.Вставить("Дата"                             , ОбщегоНазначенияКлиент.ДатаСеанса());
		СтруктураПараметров.Вставить("УникальныйИдентификатор"          , УникальныйИдентификатор);
		СтруктураПараметров.Вставить("СерийныеНомера"                   , ПогашениеПодарочныхСертификатов);
		
		РезультатОбработки = МаркетинговыеАкцииВызовСервера.ОбработатьВведенныйТекстСерийногоНомера(СтруктураПараметров, Текст, СтандартнаяОбработка);
		
		Если ТипЗнч(РезультатОбработки) = Тип("Структура") Тогда
			
			СтрокаТаблицы = ПогашениеПодарочныхСертификатов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатОбработки);
			ЧастьКода = "";
			
		ИначеЕсли ТипЗнч(РезультатОбработки) = Тип("Массив") Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("МассивСерийныхНомеров",РезультатОбработки);
			
			ОбработчикОповещения= Новый ОписаниеОповещения("ОповещениеОткрытьФормуВыбораСерийногоНомера", ЭтотОбъект);
			Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
            
            // &ЗамерПроизводительности
            ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                      Истина, "ОбщаяФорма.ФормаВыбораСерийногоНомера.Открытие");
        
			ОткрытьФорму("ОбщаяФорма.ФормаВыбораСерийногоНомера", ПараметрыФормы, ЭтотОбъект,,,, ОбработчикОповещения, Режим);
			
		ИначеЕсли ВыводитьСообщения Тогда
			ТекстСообщения = НСтр("ru = 'Нет номеров подарочных сертификатов, удовлетворяющих поиску.'"); 
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийПогашение(Таблица_ПогашениеПодарочныхСертификатов)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаВЗапрос.ПодарочныйСертификат,
	|	ТаблицаВЗапрос.СерийныйНомер
	|ПОМЕСТИТЬ ТаблицаЗапроса
	|ИЗ
	|	&ТаблицаВЗапрос КАК ТаблицаВЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапроса.ПодарочныйСертификат,
	|	ТаблицаЗапроса.СерийныйНомер,
	|	ТаблицаЗапроса.ПодарочныйСертификат.Номинал КАК Номинал,
	|	ТаблицаЗапроса.ПодарочныйСертификат.ИспользоватьСерийныеНомера КАК ИспользоватьСерийныеНомера
	|ИЗ
	|	ТаблицаЗапроса КАК ТаблицаЗапроса";
	
	Запрос.УстановитьПараметр("ТаблицаВЗапрос", Таблица_ПогашениеПодарочныхСертификатов);
	
	
	Результат = Запрос.Выполнить();
	ПогашениеПодарочныхСертификатов.Загрузить(Результат.Выгрузить());

КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеФормы(ЕстьОшибки)
	
	ИндексСтроки = 0;
	Для Каждого Строка Из ПогашениеПодарочныхСертификатов Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ПодарочныйСертификат) Тогда
				ТекстСообщения = НСтр("ru = 'Поле ""Подарочный сертификат"" не заполнено'");
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ,
												"ПогашениеПодарочныхСертификатов["+ ИндексСтроки +"].ПодарочныйСертификат");
				
				ЕстьОшибки = Истина;
		Иначе
			Если Строка.ИспользоватьСерийныеНомера И НЕ ЗначениеЗаполнено(Строка.СерийныйНомер) Тогда
				ТекстСообщения = НСтр("ru = 'Поле ""Номер подарочного сертификата"" не заполнено'");
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ,
												"ПогашениеПодарочныхСертификатов["+ ИндексСтроки +"].СерийныйНомер");
				
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНомеровСертификатов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
		|	И Номенклатура.ИспользоватьСерийныеНомера
		|	И НЕ Номенклатура.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Элементы.ЧастьКода.Видимость = Ложь;
		Элементы.ПогашениеПодарочныхСертификатовСерийныйНомер.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента, "ПогашениеПодарочныхСертификатов");
	
КонецПроцедуры

#КонецОбласти