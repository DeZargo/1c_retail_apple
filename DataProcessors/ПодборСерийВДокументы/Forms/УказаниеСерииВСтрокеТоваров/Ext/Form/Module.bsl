﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыУказанияСерий = Параметры.ПараметрыУказанияСерий;
	Магазин = Параметры.Склад;
	
	Количество = Параметры.Количество;
	GTIN = Параметры.GTIN;
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура,
		"ВидНоменклатуры,ЕдиницаИзмерения,ОсобенностьУчета");
		
	ОсобенностьУчетаНоменклатуры = РеквизитыНоменклатуры.ОсобенностьУчета;
	
	НастройкиИспользованияСерий = Новый ФиксированнаяСтруктура(ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(
																							РеквизитыНоменклатуры.ВидНоменклатуры,
																							Параметры.Магазин));
	Если Не НастройкиИспользованияСерий.ИспользоватьСерии Тогда
		ТекстИсключения = НСтр("ru = 'Для вида номенклатуры ""%ВидНоменклатуры%"" серии не используются'");
		
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ВидНоменклатуры%",НастройкиИспользованияСерий.ВидНоменклатуры);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ВидНоменклатуры = НастройкиИспользованияСерий.ВидНоменклатуры;
	
	ПараметрыЗапросаВрем = Новый Структура;
	ПараметрыЗапросаВрем.Вставить("Номенклатура", Параметры.Номенклатура);
	ПараметрыЗапросаВрем.Вставить("Характеристика", Параметры.Характеристика);
	ПараметрыЗапросаВрем.Вставить("Магазин", Параметры.Магазин);
	ПараметрыЗапросаВрем.Вставить("Регистратор", Параметры.Регистратор);
	
	ПараметрыЗапроса = Новый ФиксированнаяСтруктура(ПараметрыЗапросаВрем);
	
	Серия = Параметры.Серия;
	
	ПодключаемоеОборудованиеРТВызовСервера.ПолучитьДоступноеПодключаемоеОборудование(ИспользоватьПодключаемоеОборудование, Ложь, Ложь);
	
	#Область ГИСМ
	
	// С операцией МаркировкаПродукцииДляГИСМ эта форма открывается только
	//	 из документа ПеремаркировкаТоваровГИСМ, в этом сценарии форма работает как помощник
	ЭтоПеремаркировкаТоваровГИСМ  = ПараметрыУказанияСерий.СкладскиеОперации.Найти(
												Перечисления.СкладскиеОперации.МаркировкаПродукцииДляГИСМ) <> Неопределено;
	Если ЭтоПеремаркировкаТоваровГИСМ Тогда
		
		Если ОсобенностьУчетаНоменклатуры <> Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ Тогда
			ТекстИсключения = НСтр("ru = 'Номенклатура %Номенклатуры% не является продукцией, которую нужно маркировать для ГИСМ.'");
			ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Номенклатуры%",Параметры.Номенклатура);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
		GTINИзКиЗ = Справочники.Номенклатура.GTINКиЗ(Параметры.НоменклатураКиЗ, Параметры.ХарактеристикаКиЗ);
		
		ЭтоМаркировкаПерсонифицированнымиКиЗ = ЗначениеЗаполнено(GTINИзКиЗ);
		
		Если ЭтоМаркировкаПерсонифицированнымиКиЗ
			И GTINИзКиЗ <> GTIN Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный КиЗ предназначен для маркировки товаров с GTIN %GTINИзКиЗ%, его нельзя использовать для маркировки товара с GTIN %GTIN%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINИзКиЗ%", GTINИзКиЗ);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTIN%", GTIN);
			
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		СерияСписываемая = Параметры.СписываемаяСерия;
		СерияНовая       = Параметры.Серия;
		СерияВрем = РеквизитыВводаСерии();
		ЗаполнитьРеквизитыПоСерии(СерияВрем, СерияНовая);
		СерияНоваяКешВвода       = Новый ФиксированнаяСтруктура(СерияВрем);
		ЗаполнитьРеквизитыПоСерии(СерияВрем, СерияСписываемая);
		СерияСписываемаяКешВвода = Новый ФиксированнаяСтруктура(СерияВрем);
		
		Если Параметры.ЭтоВводНовойСерии Тогда
			НастроитьФормуПоШагу("Шаг2");
		Иначе
			НастроитьФормуПоШагу("Шаг1");
		КонецЕсли;
		
		Элементы.ОК.Заголовок = НСтр("ru = 'Готово'");
		
		Элементы.Номер.АвтоОтметкаНезаполненного = Ложь;
		
	Иначе
		
		Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание;
		Элементы.ГруппаНазад.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ГруппаНомерКИЗ.Видимость = НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии; 
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
		Элементы.Номер.Заголовок = НСтр("ru = 'Номер серии'");
	КонецЕсли;
	
	#КонецОбласти
	
	#Область RFID
	Если НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии Тогда
		Считыватели = МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам("СчитывательRFID");
		Если Считыватели.Количество() = 0 Тогда
			ПодключатьСчитывательRFID = Ложь;
		ИначеЕсли Считыватели.Количество() = 1 Тогда
			ПодключатьСчитывательRFID = Истина;
			СчитывательRFID = Считыватели[0].Ссылка;
		Иначе
			ТекстСообщения = НСтр("ru = 'К рабочему месту подключено несколько считывателей RFID. Работа одновременно с несколькими считывателями не поддерживается. Оставьте только один считываетель.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			ПодключатьСчитывательRFID = Ложь;
		КонецЕсли;
	Иначе
		ПодключатьСчитывательRFID = Ложь;
	КонецЕсли;
	
	УстановитьВидимостьКомандыЗаписиRFID();
	
	Элементы.СчитатьRFID.Видимость               = НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
													И ПодключатьСчитывательRFID;
	#КонецОбласти
	
	Элементы.ГруппаНомер.Видимость = НастройкиИспользованияСерий.ИспользоватьНомерСерии;
	Элементы.ГруппаГоденДо.Видимость = НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии;
	
	Элементы.СтатусРаботыRFID.Видимость  = НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
		И НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии;
	Элементы.СтатусРаботыRFID1.Видимость = НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
		И Не НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии;
	Элементы.СтатусРаботыRFID2.Видимость = НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
		И Не НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии
		И Не НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии;
	
	Элементы.Номер.ТолькоПросмотр = НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
		Элементы.Номер.Заголовок = НСтр("ru = 'Номер серии'");
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии Тогда
		Элементы.ГоденДо.Формат               = НастройкиИспользованияСерий.ФорматнаяСтрокаСрокаГодности;
		Элементы.ГоденДо.ФорматРедактирования = НастройкиИспользованияСерий.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
	
	ИдентификаторТекущейСтроки = Параметры.ИдентификаторТекущейСтроки;
	
	Если Параметры.ТолькоПросмотр Тогда
		Параметры.ТолькоПросмотр = Ложь; //Для исключения платформенной обработки
		
		Элементы.Номер.ТолькоПросмотр   = Истина;
		Элементы.ГоденДо.ТолькоПросмотр = Истина;
		Элементы.ОК.Доступность         = Ложь;
		
		РежимПросмотра = Истина;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	
	ЗаполнитьРеквизитыПоСерии(ЭтаФорма,Серия);
	ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Параметры.Текст)
	 И (Не ЗначениеЗаполнено(Серия) ИЛИ Параметры.Текст <> Наименование) Тогда
	 	РеквизитыСерииИзСтроки = РеквизитыСерииИзСтроки(Параметры.Текст, НастройкиИспользованияСерий);
		ЗаполнитьЗначенияСвойств(ЭтаФорма,РеквизитыСерииИзСтроки);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Номер) Тогда
		Номер = Номер + " ";
	КонецЕсли;
	
	ПравоДобавленияСерий = ПравоДоступа("Добавление", Метаданные.Справочники.СерииНоменклатуры);
	
	Если ПравоДобавленияСерий Тогда
		
		// Выведем поля для заполнения доп. реквизитов серий 
		Если ЗначениеЗаполнено(Параметры.Серия) Тогда
			СерияОбъект = Параметры.Серия.ПолучитьОбъект();
		Иначе
			СерияОбъект = Обработки.ПодборСерийВДокументы.ВладелецСвойствСерий(ВидНоменклатуры);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СтрДлина(Номер) > 0 Тогда
		Элементы.Номер.УстановитьГраницыВыделения(СтрДлина(Номер),СтрДлина(Номер));
	КонецЕсли;
	
	ИдетЗаписьМетки = Ложь;
	
    ПоддерживаемыеТипыОборудования = "СканерШтрихкода";
	
	Если ПодключатьСчитывательRFID Тогда
		ПоддерживаемыеТипыОборудования = ПоддерживаемыеТипыОборудования + ", СчитывательRFID";
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, ПоддерживаемыеТипыОборудования);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	ПодключаемоеОборудованиеРТКлиент.ОтключитьОборудованиеRFID(Неопределено, Новый Структура("Форма",ЭтаФорма));

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И НЕ ТолькоПросмотр Тогда
		
		Если ИмяСобытия = "RFID"
			И НЕ ИдетЗаписьМетки
			И ПодключаемоеОборудованиеРТКлиент.ДляОбработкиRFIDНуженСерверныйВызов(Параметр, ЭтаФорма) Тогда
			ОчиститьСообщения();
			ОбработатьСчитываниеRFID(Параметр);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьRFID_Серии" Тогда
		ОчиститьСообщения();
		RFIDEPC = Параметр.RFIDEPC;
		ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма);
		НайтиСоздатьСерию();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СерииНоменклатуры" Тогда
		ОчиститьСообщения();
		ЗаполнитьЗначенияСвойств(ЭтаФорма,Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ВводДоступен() Тогда
		
		Если Событие = "RFID" Тогда
			ОписаниеОшибки = "";
			ОписаниеСобытия = Новый Структура();
			ОписаниеСобытия.Вставить("Источник", Источник);
			ОписаниеСобытия.Вставить("Событие",  Событие);
			ОписаниеСобытия.Вставить("Данные",   Данные);
			МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
		Иначе
			ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура НомерКиЗГИСМПриИзменении(Элемент)
	
	Если ЭтоПеремаркировкаТоваровГИСМ
		И Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииНачало Тогда
		Номер = "";
		ГоденДо = Дата(1,1,1,0,0,0);
		Если ИнтеграцияГИСМКлиентСервер.ЭтоНомерКиЗ(НомерКиЗГИСМ) Тогда
			ОчиститьСообщения();
			НомерКиЗГИСМПриИзмененииСервер();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ПодобратьСериюЗавершитьВвод();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Не ОбязательныеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	ПерейтиНаСледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ВернутьсяНаПредыдущийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура СчитатьМетку(Команда)
	ОчиститьСообщения();
	ПодключаемоеОборудованиеРТКлиент.ОткрытьСессиюСчитывателяRFID(ЭтаФорма);
	ПодключитьОбработчикОжидания("ОтработатьТаймаутОжиданияСчитыванияМетки", 5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВRFID(Команда)
	ИдетЗаписьМетки = Истина;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ДанныеСерии",ДанныеСерии(ЭтаФорма));
	ПараметрыЗаписи.Вставить("Форма", ЭтаФорма);
	
	ПодключаемоеОборудованиеРТКлиент.ЗаписатьДанныеВRFID(Неопределено, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

&НаСервере
Функция НайтиСерию()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СерииНоменклатуры.Ссылка КАК Серия
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры
	|	И (СерииНоменклатуры.ГоденДо = &ГоденДо
	|			И СерииНоменклатуры.Номер = &Номер
	|		ИЛИ &ИспользоватьНомерКИЗГИСМСерии
	|			И СерииНоменклатуры.НомерКиЗГИСМ = &НомерКиЗГИСМ)";
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерСерии Тогда
		Запрос.УстановитьПараметр("Номер", СокрЛП(Номер));
	Иначе
		Запрос.УстановитьПараметр("Номер", "");
	КонецЕсли;
		
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии Тогда
		Запрос.УстановитьПараметр("ГоденДо", ГоденДо);
	Иначе
		Запрос.УстановитьПараметр("ГоденДо", '00010101000000');
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("ИспользоватьНомерКИЗГИСМСерии", НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии);
	Запрос.УстановитьПараметр("НомерКиЗГИСМ", НомерКиЗГИСМ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Серия;
	КонецЕсли;
	
	Возврат Справочники.СерииНоменклатуры.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		
		НомерКиЗГИСМ = Штрихкод;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОтработатьТаймаутОжиданияСчитыванияМетки()
	
	Если ОткрытаСессияСчитывателяRFID Тогда
		ПодключаемоеОборудованиеРТКлиент.ОтработатьТаймаутОжиданияСчитыванияМетки(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСчитываниеRFID(ДанныеМеток)
	
	ПараметрыОбработки = ПодключаемоеОборудованиеРТ.ПараметрыОбработкиСчитанныхRFIDИКиЗ();
	ЗаполнитьЗначенияСвойств(ПараметрыОбработки,ЭтаФорма);
	
	РезультатОбработки = ПодключаемоеОборудованиеРТ.ОбработатьСчитываниеRFID(ДанныеМеток, ПараметрыОбработки);
	
	Если ЗначениеЗаполнено(РезультатОбработки.ДанныеСерии) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатОбработки.ДанныеСерии);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьКомандыЗаписиRFID()
	
	ВидимостьКомандыЗаписиRFID = 
		ПодключатьСчитывательRFID
		И ПравоДобавленияСерий;
			
	Если ОсобенностьУчетаНоменклатуры = Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ Тогда
		Элементы.ЗаписатьВRFID.Видимость =
			ВидимостьКомандыЗаписиRFID
			И ЭтоПеремаркировкаТоваровГИСМ
			И Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание
			И Не ЭтоМаркировкаПерсонифицированнымиКиЗ;
													
	ИначеЕсли ОсобенностьУчетаНоменклатуры = Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ Тогда 
		Элементы.ЗаписатьВRFID.Видимость= Ложь;
	Иначе
		Элементы.ЗаписатьВRFID.Видимость =
			ВидимостьКомандыЗаписиRFID
			И НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
			И (Не ЭтоПеремаркировкаТоваровГИСМ
				Или Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание);
	КонецЕсли;	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьФлагиРаботыСМеткой(Форма)
	
	GTIN = Форма.GTIN;
	НастройкиИспользованияСерий = Форма.НастройкиИспользованияСерий;
	ЭтоМаркировкаПерсонифицированнымиКиЗ = Форма.ЭтоМаркировкаПерсонифицированнымиКиЗ;
	ДанныеСерии = ДанныеСерии(Форма);
	
	ШтрихкодированиеНоменклатурыКлиентСервер.ЗаполнитьФлагиРаботыСМеткой(ДанныеСерии, GTIN, Неопределено, НастройкиИспользованияСерий, ЭтоМаркировкаПерсонифицированнымиКиЗ);
	
	ЗаполнитьЗначенияСвойств(Форма,ДанныеСерии);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеСерии(ДанныеДляЗаполнения)
	
	ДанныеСерии = РеквизитыВводаСерии();
	ЗаполнитьЗначенияСвойств(ДанныеСерии, ДанныеДляЗаполнения);
	
	Возврат ДанныеСерии;
	
КонецФункции

&НаКлиенте
Процедура ПодобратьСериюЗавершитьВвод()
	
	Если РежимПросмотра Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ВозвращаемоеЗначение = Новый Структура("Значение,ЗначениеСписываемойСерии,ИдентификаторТекущейСтроки");
	
	Если НЕ ОбязательныеРеквизитыЗаполнены()
		Или НЕ НайтиСоздатьСерию() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ИдентификаторТекущейСтроки = ИдентификаторТекущейСтроки;
	ВозвращаемоеЗначение.Значение = Серия;
	Если ЭтоПеремаркировкаТоваровГИСМ Тогда
		ВозвращаемоеЗначение.ЗначениеСписываемойСерии = СерияСписываемая;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ОбязательныеРеквизитыЗаполнены(ВыводитьСообщения = Истина)
	
	Отказ = Ложь;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
		Если Не ЗначениеЗаполнено(НомерКиЗГИСМ) Тогда
			Отказ = Истина;
			Если ВыводитьСообщения Тогда
				ТекстСообщения = НСтр("ru = 'Поле ""Номер КиЗ"" не заполнено'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НомерКиЗГИСМ");
			КонецЕсли;
		ИначеЕсли Не ИнтеграцияГИСМКлиентСервер.ЭтоНомерКиЗ(НомерКиЗГИСМ) Тогда
			Отказ = Истина;
			Если ВыводитьСообщения Тогда
				ТекстСообщения = НСтр("ru = 'Значение в поле ""Номер КиЗ"" не является номером контрольного (идентификационного) знака ГИСМ'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НомерКиЗГИСМ");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерСерии
		И Не ЗначениеЗаполнено(Номер)
		И Не НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
		Отказ = Истина;
		Если ВыводитьСообщения Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Номер"" не заполнено'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Номер");
		КонецЕсли;
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии
		И Не ЗначениеЗаполнено(ГоденДо) Тогда
		Отказ = Истина;
		Если ВыводитьСообщения Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Годен до"" не заполнено'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ГоденДо");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Функция НайтиСоздатьСерию()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Серия = НайтиСерию();
	
	Если Не ЗначениеЗаполнено(Серия) Тогда
		
		СоздатьСерию();
		
	ИначеЕсли ПравоДобавленияСерий Тогда
	
		СерияОбъект = Серия.ПолучитьОбъект();
		
		СерияОбъект.RFIDTID  = RFIDTID;
		СерияОбъект.RFIDUser = RFIDUser;
		СерияОбъект.RFIDEPC  = RFIDEPC;
		СерияОбъект.EPCGTIN  = EPCGTIN;
		СерияОбъект.Номер    = Номер;
		СерияОбъект.ГоденДо  = ГоденДо;
		СерияОбъект.Записать();
		
		Серия = СерияОбъект.Ссылка;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(Серия);
	
КонецФункции

&НаСервере
Функция СоздатьСерию()
		
	Если Не ПравоДобавленияСерий Тогда
		
		ТекстСообщения = НСтр("ru = 'В программе еще не зарегистрирована серия %ПредставлениеСерии%. Недостаточно прав для регистрации новой серии.'");
		
		ПредставлениеСерии = МаркировкаТоваровГИСМКлиентСерверРТ.ПредставлениеСерии(НастройкиИспользованияСерий, ЭтаФорма);
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеСерии%", ПредставлениеСерии);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
		
	Иначе
	
		СерияОбъект = Справочники.СерииНоменклатуры.СоздатьЭлемент();
		СерияОбъект.Номер           = Номер;
		СерияОбъект.ВидНоменклатуры = ВидНоменклатуры;
		СерияОбъект.ГоденДо         = ГоденДо;
		СерияОбъект.НомерКИЗГИСМ    = НомерКИЗГИСМ;
			
		СерияОбъект.RFIDTID        = RFIDTID;
		СерияОбъект.RFIDUser       = RFIDUser;
		СерияОбъект.RFIDEPC        = RFIDEPC;
		СерияОбъект.EPCGTIN        = EPCGTIN;
		СерияОбъект.Номер          = Номер;
		
		СерияОбъект.Записать();
		
		Серия = СерияОбъект.Ссылка;
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыСерииИзСтроки(Знач Строка, НастройкиИспользованияСерий)
	
	РеквизитыСерии = Новый Структура("Номер,НомерКиЗГИСМ,ГоденДо","","",'00010101');
	ГоденДо = Неопределено;
	Номер   = Неопределено;
	НомерКиЗГИСМ = Неопределено;
	
	Строка = СтрЗаменить(Строка, " "+" "," ");
	
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии Тогда
		СтрокаГоденДо = "";
		Если НастройкиИспользованияСерий.ТочностьУказанияСрокаГодностиСерии 
				= ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов") Тогда
			ДлинаСтрокиГоденДо = СтрДлина(НастройкиИспользованияСерий.ФорматнаяСтрокаСрокаГодности) - 5; // 5 = СтрДлина("ДФ=''")	
		Иначе	
			ДлинаСтрокиГоденДо = СтрДлина(НастройкиИспользованияСерий.ФорматнаяСтрокаСрокаГодности) - 3; // 3 = СтрДлина("ДФ=")
		КонецЕсли;
	
		Если НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
			
			ПозицияДо = СтрНайти(Строка, НСтр("ru = 'до'"));
			СтрокаГоденДо = СокрЛП(Сред(Строка, ПозицияДо+3, ДлинаСтрокиГоденДо));
		
		Иначе
		
			СтрокаГоденДо = Прав(СокрЛП(Строка), ДлинаСтрокиГоденДо);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии Тогда
		
		Если СтрДлина(СтрокаГоденДо) <> ДлинаСтрокиГоденДо Тогда
			ГоденДо = '00010101';
		КонецЕсли;
		
		Если ГоденДо = Неопределено Тогда
			МассивЧастей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаГоденДо,".");
			
			Если МассивЧастей.Количество() < 3 Тогда
				ГоденДо = '00010101';
			КонецЕсли;
		КонецЕсли;
		
		Если ГоденДо = Неопределено Тогда
			День  = МассивЧастей[0];
			Месяц = МассивЧастей[1];
			
			Если НастройкиИспользованияСерий.ТочностьУказанияСрокаГодностиСерии 
				= ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов") Тогда
				ГодЧас =  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивЧастей[2]," ");
				Если ГодЧас.Количество() = 2 Тогда
					Год = ГодЧас[0];
					Час = ГодЧас[1];
				ИначеЕсли ГодЧас.Количество() = 1 Тогда
					Год = ГодЧас[0];
					Час = "00";
				Иначе
					Год = "00";
					Час = "00";
				КонецЕсли;
			Иначе	
				Год = МассивЧастей[2];
				Час = "00";
			КонецЕсли;
			
			Если СтрНайти(Час, ":") > 0 Тогда
				Час = Лев(Час, СтрНайти(Час, ":") - 1);
			КонецЕсли;
			
			Попытка
 				ГоденДо = Дата("20" + Год + Месяц + День + Час + "0000");
			Исключение	
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерСерии Тогда
		Если ЗначениеЗаполнено(ГоденДо) Тогда
			Номер = СтрЗаменить(Строка," " + НСтр("ru = 'до'") + " " + СтрокаГоденДо, "");
		Иначе
			Номер = Строка;
		КонецЕсли; 	
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерКИЗГИСМСерии Тогда
		Если НастройкиИспользованияСерий.ИспользоватьНомерСерии Тогда
			ПозицияКиЗ = СтрНайти(ВРег(Номер),НСтр("ru = 'КИЗ'"));
			НомерКиЗГИСМ = ВРег(СокрЛП(Сред(Номер, ПозицияКиЗ + 4)));
			Номер = СокрЛП(Лев(Номер,ПозицияКиЗ-2));
		Иначе
			Если ЗначениеЗаполнено(ГоденДо) Тогда
				НомерКиЗГИСМ = СтрЗаменить(Строка," " + НСтр("ru = 'до'") + " " + СтрокаГоденДо, "");
			Иначе
				НомерКиЗГИСМ = Строка;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Номер <> Неопределено Тогда
		РеквизитыСерии.Номер = Номер;
	КонецЕсли;
	
	Если ГоденДо <> Неопределено Тогда
		РеквизитыСерии.ГоденДо = ГоденДо;
	КонецЕсли;
	
	Если НомерКиЗГИСМ  <> Неопределено Тогда
		РеквизитыСерии.НомерКиЗГИСМ = НомерКиЗГИСМ;
	КонецЕсли;
	
	Возврат РеквизитыСерии; 
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыВводаСерии()
	РеквизитыВводаСерии = Новый Структура("Серия,
		|EPCGTIN,
		|RFIDEPC,
		|RFIDTID,
		|RFIDUser,
		|ГоденДо,
		|ЗаполненRFIDTID,
		|Номер,
		|НомерКиЗГИСМ,
		|НужноЗаписатьМетку,
		|СтатусРаботыRFID");
	Возврат РеквизитыВводаСерии;
КонецФункции

&НаСервере
Процедура ПерейтиНаСледующийШаг()
	
	Если Элементы.СтраницыСерий.ТекущаяСтраница = Элементы.СтраницаВводСерии Тогда
		Если НЕ НайтиСоздатьСерию() Тогда
			Возврат;
		КонецЕсли;
		СерияСписываемая = Серия;
	КонецЕсли;
	
	СерияСписываемаяКешВвода = Новый ФиксированнаяСтруктура(ДанныеСерии(ЭтаФорма));
	
	НастроитьФормуПоШагу("Шаг2");
	
КонецПроцедуры

&НаСервере
Процедура ВернутьсяНаПредыдущийШаг()
	
	Если Элементы.СтраницыСерий.ТекущаяСтраница = Элементы.СтраницаВводСерии Тогда
		СерияНовая = Серия;
	КонецЕсли;
	
	СерияНоваяКешВвода = Новый ФиксированнаяСтруктура(ДанныеСерии(ЭтаФорма));
	
	НастроитьФормуПоШагу("Шаг1");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоШагу(Шаг)
	
	Если Шаг = "Шаг1" Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СерияСписываемаяКешВвода);
		
		Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииНачало;
		Элементы.Далее.КнопкаПоУмолчанию = Истина;
		
		Элементы.Номер.ПодсказкаВвода = "";
		Элементы.Номер.Подсказка = "";
		
		Элементы.ГоденДо.ТолькоПросмотр = Истина;
		Элементы.ГоденДо.АвтоОтметкаНезаполненного = Ложь;
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Укажите списываемую серию'");
		ИскомаяСерия = СерияСписываемая;
	Иначе
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СерияНоваяКешВвода);
		
		Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание;
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		
		Если Не ЭтоМаркировкаПерсонифицированнымиКиЗ Тогда
			Элементы.Номер.ПодсказкаВвода = НСтр("ru = '<генерируются по данным RFID-метки>'");
			Элементы.Номер.Подсказка = НСтр("ru = 'генерируются по данным RFID-метки'");
		Иначе
			Элементы.Номер.ПодсказкаВвода = НСтр("ru = '<заполняется по данным КиЗ>'");
			Элементы.Номер.Подсказка = НСтр("ru = 'заполняется по данным КиЗ'");
		КонецЕсли;
		
		Элементы.ГоденДо.ТолькоПросмотр = Ложь;
		Элементы.ГоденДо.АвтоОтметкаНезаполненного = Истина;
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Укажите новую серию'");
		Элементы.СтраницыСерий.ТекущаяСтраница = Элементы.СтраницаВводСерии;
		ИскомаяСерия = СерияНовая;
	КонецЕсли;
	
	ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма);
	
	УстановитьВидимостьКомандыЗаписиRFID();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыПоСерии(Приемник, Знач СерияДляЗаполнения)
	
	Если ЗначениеЗаполнено(СерияДляЗаполнения) Тогда
		Если ТипЗнч(СерияДляЗаполнения) = Тип("СправочникСсылка.СерииНоменклатуры") Тогда
			Приемник.Серия = СерияДляЗаполнения;
			СерияСсылка = СерияДляЗаполнения;
		Иначе
			ЗаполнитьЗначенияСвойств(Приемник, СерияДляЗаполнения);
			СерияСсылка = СерияДляЗаполнения.Серия;
		КонецЕсли;
		Если ЗначениеЗаполнено(СерияСсылка) Тогда
			РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СерияСсылка,
				"Наименование,Номер,ГоденДо,НомерКИЗГИСМ,RFIDUser,RFIDEPC,EPCGTIN,RFIDTID");
			ЗаполнитьЗначенияСвойств(Приемник, РеквизитыСерии);
		КонецЕсли;
	Иначе
		ЗаполнитьЗначенияСвойств(Приемник, РеквизитыВводаСерии());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НомерКиЗГИСМПриИзмененииСервер()
	
	Серия = НайтиСерию();
	Если ЗначениеЗаполнено(Серия) Тогда
		ЗаполнитьРеквизитыПоСерии(ЭтаФорма,Серия);
	Иначе
		ТекстСообщения = НСтр("ru = 'В программе еще не зарегистрирована серия с номером КиЗ %НомерКиЗГИСМ%. Укажите существующую серию.'");
	 	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерКиЗГИСМ%", СокрЛП(НомерКиЗГИСМ));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"НомерКиЗГИСМ");
	КонецЕсли;
	ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
