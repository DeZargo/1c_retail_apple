﻿
&НаСервере
Процедура КочетовПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//Zorius
	//Объект.ПредъявленСчетФактура=истина;     
	Элементы.Товары.ПодчиненныеЭлементы.ТоварыСуммаВсего.ТолькоПросмотр=Ложь;
	
	Если не РольДоступна("ПолныеПрава") и ЗначениеЗаполнено(Объект.ТТНВходящаяЕГАИС) Тогда	
		Элементы.Контрагент.ТолькоПросмотр=Истина;
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава") Тогда
		Элементы.ЕстьРасхождения.ТолькоПросмотр=Ложь;
	КонецЕсли;
	
	Для каждого стр из Объект.Товары цикл
		стр.весовой=стр.номенклатура.весовой;
	КонецЦикла;
	
	
	Если ЗначениеЗаполнено(Объект.ТТНВходящаяЕГАИС)Тогда
		Элементы.Товары.ПодчиненныеЭлементы.ТоварыДатаРозлива.Видимость=Истина;
		//Если Объект.ЕстьРасхождения Тогда
			Для каждого стр из Объект.ТоварыПоДаннымПоставщика цикл
				ПроставитьДатыРозлива(стр);//Запрос в цикле - гавно переделать.
			КонецЦикла;
		//Иначе
			Для каждого стр из Объект.Товары цикл
				ПроставитьДатыРозлива(стр);//Запрос в цикле - гавно переделать.
				
				стр.маркируемый=стр.АлкогольнаяПродукция.ВидПродукции.Маркируемый;
				
			КонецЦикла;
		//КонецЕсли;
	Иначе
		Элементы.Товары.ПодчиненныеЭлементы.ТоварыДатаРозлива.Видимость=Ложь;
	КонецЕсли;
	
	//Zorius

	//
	Если РольДоступна("ПолныеПрава") или НетМаркируемойПродукции()  Тогда
		Элементы.ЕстьРасхождения.Доступность=Истина;
	Иначе
		Элементы.ЕстьРасхождения.Доступность=Ложь;
	Конецесли;
	Если РольДоступна("ПолныеПрава") Тогда
		Элементы.ххх_АкцизныеМарки.ТолькоПросмотр=Ложь;
	КонецЕсли;
	//
	//Zorius
	Если не ЗначениеЗаполнено(ЭтаФорма.Параметры.Ключ) Тогда
		
		КочетовПрвоеритьНаличиеШтрихКодовУНоменклатуры();
		
			
		Если константы.ххх_ИспользуетсяEDI.Получить() и ЗначениеЗаполнено(Объект.Контрагент) и не значениеЗаполнено(Объект.ЗаказПоставщику) Тогда
		
			мен=РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
			мен.Объект=Объект.Контрагент;
			мен.Свойство="ПартнерКонтрагента";
			мен.Прочитать();
			
			
			Если мен.Выбран() Тогда
				
				вызватьИсключение "Нельзя создавать поступление без едиайного заказа!";
						
			КонецЕсли;
			
			
		
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КочетовПрвоеритьНаличиеШтрихКодовУНоменклатуры()
	
	//Запрос=Новый запрос;
	//Запрос.УстановитьПараметр("ссылки",Объект.Товары.Выгрузить().ВыгрузитьКолонку("номенклатура"));
	//Запрос.Текст="ВЫБРАТЬ
	//             |	Штрихкоды.Владелец КАК Владелец
	//             |ИЗ
	//             |	РегистрСведений.Штрихкоды КАК Штрихкоды
	//             |ГДЕ
	//             |	НЕ Штрихкоды.Владелец В (&ссылки)";
	//выборка=Запрос.Выполнить().Выбрать();
	//Пока выборка.Следующий() Цикл
	//	Сообщить("У карточки товара: "+выборка.владелец+" нет штрихкода!!!");
	//КонецЦикла;
	
КонецПроцедуры

функция НетМаркируемойПродукции()
	
	Если ЗначениеЗАполнено(Объект.ТТНВходящаяЕГАИС) Тогда
		Для каждого стр из Объект.ТТНВходящаяЕГАИС.Товары Цикл
			Если стр.АлкогольнаяПродукция.ВидПродукции.Маркируемый Тогда
				возврат ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	возврат истина;
	
КонецФункции

&НаКлиенте
Процедура КочетовПриОткрытииПосле(Отказ)
	//Zorius	
	//Если не ЗначениеЗаполнено(ТекстСчетФактура) и не Параметры.Ключ.Пустая() Тогда
	//	Элементы.ВвестиСчетФактуру.Доступность=Истина;
	//Иначе
	//	Элементы.ВвестиСчетФактуру.Доступность=Ложь;
	//КонецЕсли;
	//ПроверитьСвязкуЕГАИСномкаНашаНомка(); Устарело 190710
	
	Элементы.ЦенаВключаетНДС.ТолькоПросмотр=истина;
	//ЭтаФорма.ТолькоПросмотр=не ПроверкаРоли();
	//ЭтаФорма.Элементы.ЕстьРасхождения.ТолькоПросмотр=не ПроверкаРоли();
	//ЭтаФорма.Элементы.ЕстьРасхождения.Доступность=ПроверкаРоли();
	
	//Если Не значениеЗАполнено(Параметры.Ключ) Тогда
	//	Если ЗначениеЗаполнено (Объект.ЗаказПоставщику) Тогда
	//		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос",ЭтотОбъект); // Прописываем название процедуры-обработчика.
	//		ПоказатьВопрос(Оповещение, "Заполнить товарами из заказа?", РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да);
	//		Элементы.Товары.ПодчиненныеЭлементы.ТоварыКоличествоУпаковок1.ТолькоПросмотр=Истина;
	//	КонецЕсли;
	//КонецЕсли;
	//Zorius
КонецПроцедуры

&НаКлиенте
процедура ПослеОтветаНаВопрос(Результат, Параметры) экспорт
	
	
	ПослеОтветаНаВопросСервер(Результат);
		
КонецПроцедуры

Процедура ПослеОтветаНаВопросСервер(КодВозвратаДиалога)
	Если КодВозвратаДиалога=КодВозвратаДиалога.Нет Тогда
		Объект.Товары.Очистить();
	Иначе
		Объект.Товары.Загрузить(Объект.ЗаказПоставщику.Товары.выгрузить())
	КонецЕсли;
КонецПроцедуры
	
&НаКлиенте
Процедура ПередатьДанныеВЕГАИС(Команда)	
	Если ЭтотОбъект.Модифицированность Тогда
		Сообщить("Данные документа были изменены. Перед отправкой в ЕГАИС необходимо записать документ!");
		возврат;
	КонецЕсли;
	
	Если Объект.ТоварыПоДаннымПоставщика.Количество()>0 и Объект.Товары.Итог("Количество")<>Объект.ТоварыПоДаннымПоставщика.Итог("Количество") Тогда	
		ПоказатьВопрос(Новый ОписаниеОповещения("ОповещениеНачалоПередачиДанныхВЕГАИС",ЭтаФОрма,),"Вы собираетесь передать акт расхождений!",РежимДиалогаВопрос.ДаНет);
	Иначе
		ПодтвердитьТТН();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеНачалоПередачиДанныхВЕГАИС(Ответ,йцу) экспорт
	
	Если Ответ=КодВозвратаДиалога.Да тогда
		ПодтвердитьТТН();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьТТН()
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеПередачаДанныхВЕГАИС", ЭтотОбъект);
	
	ПараметрыПередачиВЕГАИС = ПараметрыПередачиВЕГАИС(Объект.Ссылка);
	
	Если НЕ ПараметрыПередачиВЕГАИС.Отказ Тогда
		ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ПараметрыПередачиВЕГАИС.ВидДокумента);
		ВходныеПараметры.ДокументСсылка = ПараметрыПередачиВЕГАИС.ДокументСсылка;
		ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(ОбработчикОповещения, ПараметрыПередачиВЕГАИС.ВидДокумента, ВходныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПередачаДанныхВЕГАИС(ДанныеОтЕГАИС, ДополнительныеПараметры) Экспорт
	
	//Если НЕ ДанныеОтЕГАИС = Неопределено Тогда
	//	Если ДанныеОтЕГАИС.Результат Тогда
	//		АктПереданВЕГАИС = Истина;
	//		Оповестить("ОбновитьСписокЗапросовЕГАИС");
	//	КонецЕсли;
	//	
	//	УстановитьДоступностьЭлементовЕГАИС();
	//КонецЕсли;
	
КонецПроцедуры


	
Процедура ПроверитьСвязкуЕГАИСномкаНашаНомка()	
	Если ЗначениеЗаполнено(Объект.ТТНВходящаяЕГАИС) и ТипЗнч(Объект.ТТНВходящаяЕГАИС) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда	
		Запрос=Новый запрос;
		Запрос.УстановитьПараметр("ссылка",Объект.ТТНВходящаяЕГАИС);
		Запрос.Текст="ВЫБРАТЬ
		             |	ТТНВходящаяЕГАИСТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция
		             |ПОМЕСТИТЬ ТТНномка
		             |ИЗ
		             |	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
		             |ГДЕ
		             |	ТТНВходящаяЕГАИСТовары.Ссылка = &ссылка
		             |
		             |СГРУППИРОВАТЬ ПО
		             |	ТТНВходящаяЕГАИСТовары.АлкогольнаяПродукция
		             |;
		             |
		             |////////////////////////////////////////////////////////////////////////////////
		             |ВЫБРАТЬ
		             |	ТТНномка.АлкогольнаяПродукция.Код КАК АлкогольнаяПродукцияКод,
		             |	ТТНномка.АлкогольнаяПродукция.Представление КАК АлкогольнаяПродукцияПредставление
		             |ИЗ
		             |	ТТНномка КАК ТТНномка
		             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
		             |		ПО (СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = ТТНномка.АлкогольнаяПродукция)
		             |ГДЕ
		             |	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция ЕСТЬ NULL";
		выборка=Запрос.Выполнить().Выбрать();
		строкаКодов="";
		Пока выборка.Следующий() Цикл		
			строкаКодов=строкаКодов+Выборка.АлкогольнаяПродукцияКод+"  "+Выборка.АлкогольнаяПродукцияПредставление+", ";
		КонецЦикла;
		
		Если строкаКодов<>"" Тогда
			Сообщить("По нижеследующим ФСРАР кодам, возможно, отсутсвует сввязка Номенклатуры ЕГАИС с нашей номенклатурой. Обратитесь к менеджеру алкоголя. Спросите есть ли связки по кодам ФСРАР, и если есть пусть отправят вам коды карточек из нашей базы");
			Сообщить("Если алкоменеджер ответит что связка есть. Тогда необходимо обратится к менеджеру ответственному за допуски, отправить ей те коды что прислал алкоменеджер. После того как она проставит допуски и отправит обновления, необходимо их принять");
			Сообщить("Если вышеперечисленные действия были выполнены, необходимо перефоформить поступление товаров");
			Сообщить(строкаКодов);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


//Zorius
&НаКлиенте
Процедура ххх_ПроверитьНаличиеНоменклатуры(Команда)
	Штрихкод = "";
	ТекстЗаголовка = НСтр("ru = 'Введите штрихкод'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоШтрихкодуНоменклатуры", ЭтаФорма);	
	ПоказатьВводСтроки(ОписаниеОповещения, Штрихкод, ТекстЗаголовка);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкодуНоменклатуры(Штрихкод, ДополнительныеПараметры) Экспорт	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкод(Штрихкод);
		Если СтруктураПараметровКлиента.ЗначенияПоиска.Количество()>0 тогда
			УстановитьСтатусПоиска(СтруктураПараметровКлиента.ЗначенияПоиска[0].Номенклатура);
		Иначе
			Сообщить("Номенклатура не найдена!");
		КонецЕсли;
		ххх_ПроверитьНаличиеНоменклатуры("");		
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПолученШтрихкод(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции


Процедура УстановитьСтатусПоиска(Номенклатура)
	Отбор=Новый структура;
	Отбор.Вставить("Номенклатура",Номенклатура);
	Товары=РеквизитФормыВЗначение("Объект.Товары");
	Строки=Товары.НайтиСтроки(Отбор);
	Для каждого стр из строки Цикл
		стр.СтатусПоискаНаличияНоменклатуры=Истина;
		Сообщить("Найдена номенклатура в строке: "+стр.номерСтроки);
	КонецЦикла;
КонецПроцедуры


функция получитьПапкуПоставщики()
	возврат справочники.ххх_Справочник.КонтрагентыПапкаПОСТАВЩИКИ.Значение;
КонецФункции

&НаКлиенте
Процедура ТоварыКоличествоУпаковок1ПриИзменении(Элемент)
	ПриИзмененииТоварыКоличестваУпаковок();
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСчетФактуру(Команда)
	ВвестиСчетФактуруНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВвестиСчетФактуруНаСервере()
	ДанныеСчетаФактуры = ЗакупкиСервер.ДанныеСчетаФактурыСтруктурой(
			Объект.Ссылка,
			Объект.Организация,
			Объект.Контрагент,
			Объект.НомерСчетаФактуры,
			Объект.ДатаСчетаФактуры);
		НастроитьОтображениеРеквизитовСчетаФактуры(
			ЭтаФорма,
			ЗакупкиСервер.ВвестиСчетФактуру(ДанныеСчетаФактуры, Истина))
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоЦенамЗакупаНаСервере()
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("тз",объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("Розница",Справочники.ххх_Справочник.ЗакупочнаяЦена.Значение);
	Запрос.Текст="ВЫБРАТЬ
	             |	тз.Номенклатура КАК Номенклатура,
	             |	тз.НомерСтроки КАК НомерСтроки
	             |ПОМЕСТИТЬ йцу
	             |ИЗ
	             |	&тз КАК тз
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	             |	йцу.Номенклатура КАК Номенклатура,
	             |	йцу.НомерСтроки КАК НомерСтроки
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ВидЦены = &Розница) КАК ЦеныНоменклатурыСрезПоследних
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ йцу КАК йцу
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = йцу.Номенклатура";
				 
	Выборка=Запрос.Выполнить().Выбрать();
	Пока выборка.Следующий() цикл
		Объект.товары[выборка.НомерСтроки-1].цена=выборка.цена;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЦенамЗакупа(Команда)
	ЗаполнитьПоЦенамЗакупаНаСервере();
	Для каждого стр из Объект.Товары Цикл
		ТекущаяСтрока = стр;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиТоварыКлиент.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
		СтруктураДействий.Вставить("ПересчитатьСумму");
		
		ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Объект.Товары, ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ЗаполнитьСуммуВсегоВСтрокеТаблицы(ТекущаяСтрока, Объект.ЦенаВключаетНДС);
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ОбновитьСуммыПодвала(Объект.Товары, Объект.ЦенаВключаетНДС, СуммаВсего);
		ОбновитьИтоговыеПоказатели();
		
		РассчитатьОтклонениеЦен(ТекущаяСтрока);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоАкцизнойМарке()
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоАкцизнойМарке", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.ххх_ФормаПоискаПоАкцизнойМарке",,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ОповещениеПоискаПоАкцизнойМарке(Итог,куйня) Экспорт
	Если значениеЗаполнено(Итог) и значениеЗаполнено(Итог.Номка) и Не значениеЗаполнено(Итог.штрихКод) Тогда
		Сообщить("У номенклатуры: "+Строка(Итог.Номка)+" не найден штрихкод!");
	КонецЕсли;

	стр=Неопределено;
	
	Если Значениезаполнено(Итог) Тогда
		Если Не ЗначениеЗаполнено(Объект.АкцизныеМарки.НайтиСтроки(Новый структура("АкцизнаяМарка",итог.АкцизнаяМарка))) Тогда
			//строкаАкцизныхМарок=Объект.ххх_АкцизныеМарки.Добавить();
			//строкаАкцизныхМарок.АкцизнаяМарка=итог.АкцизнаяМарка;
		Иначе
			Сообщить("Нельзя считывать одну и ту же акцизную марку!!!");
			Возврат;
		КонецЕсли;
		НомкаПоДаннымПоставщика=Объект.ТоварыПоДаннымПоставщика.НайтиСтроки(Новый структура("Номенклатура",итог.номка));
		Если ЗначениеЗаполнено(Итог.Номка) и ЗначениеЗаполнено(НомкаПоДаннымПоставщика) Тогда
			строки=Объект.товары.НайтиСтроки(Новый структура("АлкогольнаяПродукция",итог.АлкоНомка));		
			стр=?(ЗначениеЗаполнено(строки),
				ПолучитьСтрокуВЗависимостиОтТогоЧтоХватаетЛиКоличестваПриСверкеПоИдентификаторуСтроки(строки),
				неопределено);
			Если стр<>Неопределено Тогда
				стр.КоличествоУпаковок=стр.КоличествоУпаковок+1;
				стр.Количество=стр.Количество+1;
			Иначе
				Если Объект.ТоварыПоДаннымПоставщика.НайтиСтроки(Новый структура("АлкогольнаяПродукция",итог.АлкоНомка)).количество()=0 Тогда
					сообщить("По коду ФСРАР: "+итог.Алкокод+" не найдена номенклатура в накладной ЕГАИС");
				Иначе
					стрПоДаннымПоставщика=Объект.ТоварыПоДаннымПоставщика.НайтиСтроки(Новый структура("АлкогольнаяПродукция",итог.АлкоНомка))[0];  
					стр=Объект.товары.добавить();
					стр.Номенклатура=итог.номка;
					стр.КоличествоУпаковок=1;	
					стр.Количество=1;
					стр.АлкогольнаяПродукция=стрПоДаннымПоставщика.АлкогольнаяПродукция;
					стр.ИдентификаторСтроки=стрПоДаннымПоставщика.ИдентификаторСтроки;
					стр.ИдентификаторУпаковки=стрПоДаннымПоставщика.ИдентификаторУпаковки;
					стр.ДатаРозлива=стрПоДаннымПоставщика.ДатаРозлива;
					стр.маркируемый=Итог.Маркируемый;
				КонецЕсли;
			КонецЕсли;
			попытка
				стр.ПолучитьИдентификатор();
				Элементы.Товары.ТекущаяСтрока=стр.ПолучитьИдентификатор();
				ТоварыНоменклатураПриИзменении("");	
			исключение
			КонецПопытки;
		ИначеЕсли не ЗначениеЗаполнено(НомкаПоДаннымПоставщика) Тогда
			Сообщить("Данной позиции нет в ТТН из ЕГАИСа! "+Итог.Алкокод);
		Иначе
			Сообщить("Не найдена связка номенклатура с алкокодом: "+Итог.Алкокод+". Обратитесь к менеджерам");
		КонецЕсли;
		
		//Если не стр=неопределено Тогда
		//	строкаАкцизныхМарок=Объект.ххх_АкцизныеМарки.Добавить();
		//	строкаАкцизныхМарок.АкцизнаяМарка=итог.АкцизнаяМарка;
		//	строкаАкцизныхМарок.СправкаБ=НайтиБСправкуВТТН(стр.ИдентификаторСтроки);
		//	строкаАкцизныхМарок.ИдентификаторСтроки=стр.ИдентификаторСтроки;
		////	Если Не ЗначениеЗаполнено(строкаАкцизныхМарок.СправкаБ) Тогда
		////		Объект.ххх_АкцизныеМарки.Удалить(строкаАкцизныхМарок.ПолучитьИдентификатор());
		////	КонецЕсли;
		////Иначе
		////	Объект.ххх_АкцизныеМарки.Удалить(строкаАкцизныхМарок.ПолучитьИдентификатор());
		//КонецЕсли;
		НайтиПоАкцизнойМарке();		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтрокуВЗависимостиОтТогоЧтоХватаетЛиКоличестваПриСверкеПоИдентификаторуСтроки(строки)
	Для каждого стр из строки цикл
		строкиПоДаннымПоставщика=Объект.ТоварыПоДаннымПоставщика.НайтиСтроки(Новый структура("ИдентификаторСтроки",стр.ИдентификаторСтроки));
		если строкиПоДаннымПоставщика[0].КоличествоУпаковок>стр.КоличествоУпаковок Тогда
			стр.ИдентификаторСтроки=строкиПоДаннымПоставщика[0].ИдентификаторСтроки;
			возврат стр;
		Иначе
			строкиПоДаннымПоставщика=Объект.ТоварыПоДаннымПоставщика.НайтиСтроки(Новый структура("АлкогольнаяПродукция",строки[0].АлкогольнаяПродукция)); 
			Для каждого строкаПоДаннымПоставщика из строкиПоДаннымПоставщика цикл
				Если не ЗначениеЗаполнено(Объект.товары.НайтиСтроки(Новый структура("АлкогольнаяПродукция,ИдентификаторСтроки",строки[0].АлкогольнаяПродукция,строкаПоДаннымПоставщика.ИдентификаторСтроки))) Тогда
					стр1=Объект.товары.добавить();
					стр1.Номенклатура=стр.Номенклатура;
					стр1.АлкогольнаяПродукция=строкаПоДаннымПоставщика.АлкогольнаяПродукция;
					стр1.ИдентификаторСтроки=строкаПоДаннымПоставщика.ИдентификаторСтроки;
					стр1.ИдентификаторУпаковки=строкаПоДаннымПоставщика.ИдентификаторУпаковки;
					стр1.ДатаРозлива=строкаПоДаннымПоставщика.ДатаРозлива;
					стр1.маркируемый=Истина;
					возврат стр1;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	вызватьисключение "Количество товара в наклодной меньше, чем вы пытаетесь завести!";
КонецФункции
//Zorius


Процедура ПроставитьДатыРозлива(стр)
	
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("ид",стр.ИдентификаторСтроки);
	Запрос.УстановитьПараметр("ТТН",Объект.ТТНВходящаяЕГАИС);
	Запрос.Текст="ВЫБРАТЬ
	             |	ТТНВходящаяЕГАИСТовары.Справка2.НомерСправки1 КАК СправкаБНомерСправкиА,
	             |	ТТНВходящаяЕГАИСТовары.Справка2 КАК СправкаБ
	             |ПОМЕСТИТЬ Асправка
	             |ИЗ
	             |	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	             |ГДЕ
	             |	ТТНВходящаяЕГАИСТовары.Ссылка = &ттн
	             |	И ТТНВходящаяЕГАИСТовары.ИдентификаторСтроки = &ид
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	СправкаБНомерСправкиА
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	СправкиАЕГАИС.ДатаРозлива КАК ДатаРозлива,
	             |	Асправка.СправкаБ КАК СправкаБ
	             |ИЗ
	             |	Асправка КАК Асправка
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Справки1ЕГАИС КАК СправкиАЕГАИС
	             |		ПО Асправка.СправкаБНомерСправкиА = СправкиАЕГАИС.РегистрационныйНомер
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	СправкиАЕГАИС.ДатаРозлива,
	             |	Асправка.СправкаБ";
	выборка=запрос.Выполнить().Выбрать();
	Если выборка.Следующий() Тогда
		стр.ДатаРозлива=выборка.ДатаРозлива;
	КонецЕсли;
	
КонецПроцедуры





функция НайтиБСправкуВТТН(ид)
	//тз=Объект.ТТНВходящаяЕГАИС.Товары;
	//возврат тз.Найти(ид,"ИдентификаторСтроки").СправкаБ;
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьАкцизныеМарки(Команда)
	
	Если не МожноЗафиксироватьАкцизныеМарки()Тогда
		сообщить("отсутствует положительный ответ от поставщика! Прежде чем фиксировать акцизы, необходимо подтвердит ТТН.");
		возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Модифицированность Тогда
		Сообщить("Данные документа были изменены. Перед отправкой в ЕГАИС необходимо записать документ!");
		возврат;
	КонецЕсли;
	
	Объект.ххх_АкцизныеМаркиЗафиксированы=истина;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеПередачаДанныхВЕГАИС", ЭтотОбъект);
	
	ПараметрыПередачиВЕГАИС = ПараметрыПередачиВЕГАИС(Объект.Ссылка);
	
	ПараметрыПередачиВЕГАИС.ВидДокумента=ВидДокументаФиксацияАкцизов();
	
	Если НЕ ПараметрыПередачиВЕГАИС.Отказ Тогда
		ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ПараметрыПередачиВЕГАИС.ВидДокумента);
		ВходныеПараметры.ДокументСсылка = ПараметрыПередачиВЕГАИС.ДокументСсылка;
		
		ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(ОбработчикОповещения, ПараметрыПередачиВЕГАИС.ВидДокумента, ВходныеПараметры);
	КонецЕсли;

КонецПроцедуры

функция МожноЗафиксироватьАкцизныеМарки()
	
	Если ЗначениеЗаполнено(Объект.ТТНВходящаяЕГАИС) и 
		(Объект.ТТНВходящаяЕГАИС.СтатусОбработки = Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктПодтверждения или
		Объект.ТТНВходящаяЕГАИС.СтатусОбработки = Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПринятоПодтверждениеАктаРасхождений) Тогда
		возврат истина;
	Иначе
		возврат ложь;
	КонецЕсли;
	
КонецФункции


Функция ВидДокументаФиксацияАкцизов()
	возврат перечисления.ВидыДокументовЕГАИС.ххх_АктФиксацииМарок;
КонецФункции

&НаКлиенте
Процедура РазфиксироватьАкцизныеМарки()
	
	Если ЭтотОбъект.Модифицированность Тогда
		Сообщить("Данные документа были изменены. Перед отправкой в ЕГАИС необходимо записать документ!");
		возврат;
	КонецЕсли;
	
	Объект.ххх_АкцизныеМаркиЗафиксированы=истина;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеПередачаДанныхВЕГАИС", ЭтотОбъект);
	
	ПараметрыПередачиВЕГАИС = ПараметрыПередачиВЕГАИС(Объект.Ссылка);
	
	ПараметрыПередачиВЕГАИС.ВидДокумента=ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ххх_АктРазфиксацииМарок");
	
	Если НЕ ПараметрыПередачиВЕГАИС.Отказ Тогда
		ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ПараметрыПередачиВЕГАИС.ВидДокумента);
		ВходныеПараметры.ДокументСсылка = ПараметрыПередачиВЕГАИС.ДокументСсылка;
		
		ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(ОбработчикОповещения, ПараметрыПередачиВЕГАИС.ВидДокумента, ВходныеПараметры);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыПередачиВЕГАИС(ДокументСсылка)
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "ЕстьРасхождения, ТТНВходящаяЕГАИС");
	
	Результат = Новый Структура;
	Результат.Вставить("ВидДокумента"  , Перечисления.ВидыДокументовЕГАИС.АктПодтвержденияТТН);
	Результат.Вставить("ДокументСсылка", ЗначенияРеквизитов.ТТНВходящаяЕГАИС);
	Результат.Вставить("Отказ"         , Ложь);
	
	Если НЕ ЗначенияРеквизитов.ЕстьРасхождения Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеТоваровТоварыПоДаннымПоставщика.НомерСтроки КАК НомерСтроки,
	|	ПоступлениеТоваровТоварыПоДаннымПоставщика.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ПоступлениеТоваровТоварыПоДаннымПоставщика.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ПоступлениеТоваровТоварыПоДаннымПоставщика.КоличествоУпаковок КАК Количество
	|ПОМЕСТИТЬ ТаблицаПоступленияДанныеПоставщика
	|ИЗ
	|	Документ.ПоступлениеТоваров.ТоварыПоДаннымПоставщика КАК ПоступлениеТоваровТоварыПоДаннымПоставщика
	|ГДЕ
	|	ПоступлениеТоваровТоварыПоДаннымПоставщика.Ссылка = &Ссылка
	|	И НЕ ПоступлениеТоваровТоварыПоДаннымПоставщика.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТТНВходящаяЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	ТТНВходящаяЕГАИСТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТТНВходящаяЕГАИСТовары.Ссылка КАК Ссылка,
	|	ТТНВходящаяЕГАИСТовары.СправкаБ КАК СправкаБ
	|ПОМЕСТИТЬ ТаблицаТТН
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	|ГДЕ
	|	ТТНВходящаяЕГАИСТовары.Ссылка = &СсылкаТТН
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПоступленияДанныеПоставщика.НомерСтроки КАК НомерСтроки,
	|	ТаблицаПоступленияДанныеПоставщика.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаПоступленияДанныеПоставщика.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаПоступленияДанныеПоставщика.Количество КАК Количество,
	|	ТаблицаТТН.СправкаБ КАК СправкаБ
	|ПОМЕСТИТЬ ТаблицаТТНПоДаннымПоставщика
	|ИЗ
	|	ТаблицаПоступленияДанныеПоставщика КАК ТаблицаПоступленияДанныеПоставщика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаТТН КАК ТаблицаТТН
	|		ПО ТаблицаПоступленияДанныеПоставщика.ИдентификаторСтроки = ТаблицаТТН.ИдентификаторСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеТоваровТовары.НомерСтроки КАК НомерСтроки,
	|	ПоступлениеТоваровТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ВЫБОР
	|		КОГДА ПоступлениеТоваровТовары.Номенклатура.ВидНоменклатуры.ПродаетсяВРозлив
	|			ТОГДА ПоступлениеТоваровТовары.Количество * ПоступлениеТоваровТовары.Номенклатура.ОбъемДАЛ
	|		ИНАЧЕ ПоступлениеТоваровТовары.КоличествоУпаковок
	|	КОНЕЦ КАК Количество
	|ПОМЕСТИТЬ ТоварыПоФакту
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК ПоступлениеТоваровТовары
	|ГДЕ
	|	ПоступлениеТоваровТовары.Ссылка = &Ссылка
	|	И НЕ ПоступлениеТоваровТовары.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТоварыПоФакту.НомерСтроки, 0) КАК НомерСтроки,
	|	ТаблицаТТНПоДаннымПоставщика.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаТТНПоДаннымПоставщика.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТТНПоДаннымПоставщика.Количество КАК Количество,
	|	ТаблицаТТНПоДаннымПоставщика.СправкаБ КАК СправкаБ,
	|	ЕСТЬNULL(ТоварыПоФакту.Количество, 0) КАК КоличествоФакт
	|ПОМЕСТИТЬ ТаблицаСравнения
	|ИЗ
	|	ТаблицаТТНПоДаннымПоставщика КАК ТаблицаТТНПоДаннымПоставщика
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыПоФакту КАК ТоварыПоФакту
	|		ПО ТаблицаТТНПоДаннымПоставщика.ИдентификаторСтроки = ТоварыПоФакту.ИдентификаторСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСравнения.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСравнения.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаСравнения.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаСравнения.СправкаБ КАК СправкаБ,
	|	ТаблицаСравнения.Количество КАК Количество,
	|	ТаблицаСравнения.КоличествоФакт КАК КоличествоФакт
	|ИЗ
	|	ТаблицаСравнения КАК ТаблицаСравнения
	|ГДЕ
	|	ТаблицаСравнения.Количество <> ТаблицаСравнения.КоличествоФакт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСравнения.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСравнения.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаСравнения.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаСравнения.СправкаБ КАК СправкаБ,
	|	ТаблицаСравнения.Количество КАК Количество,
	|	ТаблицаСравнения.КоличествоФакт КАК КоличествоФакт
	|ИЗ
	|	ТаблицаСравнения КАК ТаблицаСравнения";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("СсылкаТТН", ЗначенияРеквизитов.ТТНВходящаяЕГАИС);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Отказ = Ложь;
	
	ТаблицаРасхождений = Новый ТаблицаЗначений;
	ТаблицаРасхождений.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаРасхождений.Колонки.Добавить("ИдентификаторСтроки", Новый ОписаниеТипов("Строка"));
	ТаблицаРасхождений.Колонки.Добавить("КоличествоФакт", Новый ОписаниеТипов("Число"));
	
	ВыборкаПроверкиРасхождений = МассивРезультатов[5].Выбрать();
	Если ВыборкаПроверкиРасхождений.Количество() > 0 Тогда
		Выборка = МассивРезультатов[6].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Результат.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктРасхожденийТТН;
			
			Если Выборка.КоличествоФакт > Выборка.Количество Тогда
				СтрокаОшибки = НСтр("ru = 'В строке %1 фактическое количество %2 превышает количество поставщика %3, передача такого расхождения в ЕГАИС не допускается.'");
				СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					СтрокаОшибки,
					Выборка.НомерСтроки,
					Выборка.КоличествоФакт,
					Выборка.Количество);
				Если Выборка.НомерСтроки > 0 Тогда
					ИмяПоляТоваров = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", Выборка.НомерСтроки, "КоличествоУпаковок");
				Иначе
					ИмяПоляТоваров = "Объект.Товары";
				КонецЕсли;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрокаОшибки,
					ДокументСсылка,
					ИмяПоляТоваров);
					
				Отказ = Истина;
			КонецЕсли;
			
			СтрокаРасхождений = ТаблицаРасхождений.Добавить();
			СтрокаРасхождений.НомерСтроки = Выборка.НомерСтроки;
			СтрокаРасхождений.ИдентификаторСтроки = Выборка.ИдентификаторСтроки;
			СтрокаРасхождений.КоличествоФакт = Выборка.КоличествоФакт;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Отказ И ТаблицаРасхождений.Количество() > 0 Тогда
		ТТН = ЗначенияРеквизитов.ТТНВходящаяЕГАИС.ПолучитьОбъект();
		ТТН.Товары.ЗагрузитьКолонку(Новый Массив(ТТН.Товары.Количество()), "КоличествоФакт");
		
		Для Каждого СтрокаРасхождений Из ТаблицаРасхождений Цикл
			СтрокаТЧ = ТТН.Товары.Найти(СтрокаРасхождений.ИдентификаторСтроки, "ИдентификаторСтроки");
			Если СтрокаТЧ = Неопределено Тогда
				СтрокаОшибки = НСтр("ru = 'В строке %1 указан неизвестный идентификатор %2 строки ТТН.'");
				СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					СтрокаОшибки,
					СтрокаРасхождений.НомерСтроки,
					СтрокаРасхождений.ИдентификаторСтроки);
				
				Если СтрокаРасхождений.НомерСтроки > 0 Тогда
					ИмяПоляТоваров = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", СтрокаРасхождений.НомерСтроки, "Номенклатура");
				Иначе
					ИмяПоляТоваров = "Объект.Товары";
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрокаОшибки,
					ДокументСсылка,
					ИмяПоляТоваров,,
					Отказ);
			Иначе
				СтрокаТЧ.КоличествоФакт = СтрокаРасхождений.КоличествоФакт;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Отказ Тогда
			ТТН.Записать();
		КонецЕсли;
	КонецЕсли;
	
	Результат.Отказ = Отказ;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УдалитьПоАкцизнойМарке(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоАкцизнойМаркеУдаление", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.ххх_ФормаПоискаПоАкцизнойМарке",,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ОповещениеПоискаПоАкцизнойМаркеУдаление(Итог,куйня) Экспорт

	УдалитьСтрокиПоАкцизу(итог)
	
КонецПроцедуры

Процедура УдалитьСтрокиПоАкцизу(итог)

	Если Значениезаполнено(Итог) Тогда
		//ххх_АкцизныеМарки=Объект.ххх_АкцизныеМарки.Выгрузить();
		//СтрокаМарок=ххх_АкцизныеМарки.Найти(итог.АкцизнаяМарка);
		СтрокаМарок=Объект.АкцизныеМарки.НайтиСтроки(Новый структура("АкцизнаяМарка",итог.АкцизнаяМарка));
		Если СтрокаМарок.количество()>0 Тогда
			СтрокаМарок=СтрокаМарок[0];
			//товары=Объект.Товары.Выгрузить();
			//СтрокаТовары=товары.найти(СтрокаМарок.ИдентификаторСтроки);
			СтрокаТоваров=Объект.Товары.НайтиСтроки(Новый структура("ИдентификаторСтроки",СтрокаМарок.ИдентификаторСтроки))[0];
			Если строкаТоваров.количество>1 Тогда
				строкаТоваров.количество=строкаТоваров.количество-1;
				строкаТоваров.КоличествоУпаковок=строкаТоваров.количество;
				Объект.АкцизныеМарки.Удалить(Объект.АкцизныеМарки.индекс(СтрокаМарок));
			Иначе
				Объект.Товары.Удалить(Объект.Товары.индекс(строкаТоваров));
				Объект.АкцизныеМарки.Удалить(Объект.АкцизныеМарки.индекс(СтрокаМарок));
			КонецЕсли;
		Иначе
			Сообщить("Данная марка отсутствует в накладной!");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	




&НаКлиенте
&Вместо("ОповещениеПоискаПоШтрихкоду")
Процедура ОповещениеПоискаПоШтрихкодуКочетов(Структура, ДополнительныеПараметры) Экспорт	
	Если ЗначениеЗаполнено(Структура) Тогда
		штрихкод=Структура.штрихкод;
		Если Структура.ПоискПоВесовомуТовару=Ложь тогда
			СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
			ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
			ТекущаяСтрокаЕГАИС = Неопределено;
		Иначе			
			Элементы.Товары.ТекущаяСтрока=ПоискПоВесовомуШтрихКоду(штрихкод);
			ТоварыНоменклатураПриИзменении("");
		КонецЕсли;
		//Zorius
		ПоискПоШтрихкоду("");
		//Zorius
	КонецЕсли;
КонецПроцедуры

Функция ПоискПоВесовомуШтрихКоду(штрихкод)
	номка=ххх_Сервер.ПолучитьВесовойШтрихкод(штрихкод);  //23 12647 00182 0
	Если значениеЗаполнено(номка) Тогда
		
		вес=Число(Лев(Прав(штрихкод,6),5)/1000);
		
		строки=Объект.товары.НайтиСтроки(Новый структура("Номенклатура",номка));
		
		стр=?(ЗначениеЗаполнено(строки),строки[0],неопределено);
		Если стр<>Неопределено Тогда
			стр.количество=стр.количество+вес;
			стр.количествоУпаковок=стр.количество;
		Иначе
			стр=Объект.товары.добавить();
			стр.Номенклатура=номка;
			стр.количество=вес;
			стр.количествоУпаковок=стр.количество;
		КонецЕсли;
		возврат стр.ПолучитьИдентификатор();
	Иначе
		Сообщить("Данные по коду не найдены: "+штрихкод);
		возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура КочетовТоварыКоличествоУпаковок1ПриИзмененииВместо(Элемент)
	ПриИзмененииТоварыКоличестваУпаковок();
КонецПроцедуры

&НаКлиенте
Процедура КочетовЕстьРасхожденияПриИзмененииПосле(Элемент)
	Элементы.Товары.ПодчиненныеЭлементы.ТоварыКоличествоУпаковок1.ТолькоПросмотр=Не Объект.ЕстьРасхождения;
КонецПроцедуры

&НаСервере
Процедура КочетовКонтрагентПриИзмененииПослеНаСервере()
	
	
	Если константы.ххх_ИспользуетсяEDI.Получить() и ЗначениеЗаполнено(Объект.Контрагент) Тогда
	
		мен=РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
		мен.Объект=Объект.Контрагент;
		мен.Свойство="ПартнерКонтрагента";
		мен.Прочитать();
		
		
		Если мен.Выбран() Тогда
			
			Объект.Контрагент=Неопределено;
			сообщить("Нельзя выбирать едиайного поставщика!");
					
		КонецЕсли;
		
		
	
	КонецЕсли;
	

	
КонецПроцедуры

&НаКлиенте
Процедура КочетовКонтрагентПриИзмененииПосле(Элемент)
	КочетовКонтрагентПриИзмененииПослеНаСервере();
КонецПроцедуры

























