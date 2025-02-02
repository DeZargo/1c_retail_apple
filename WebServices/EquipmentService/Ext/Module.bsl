﻿
#Область СлужебныеПроцедурыИФункции

Функция Connect(DeviceID)
	
	СоединениеУспешно = МенеджерОфлайнОборудованияWebСервис.Соединиться(DeviceID);
	Возврат СоединениеУспешно;
	
КонецФункции

Функция GetSettings(DeviceID)
	
	Настройки = МенеджерОфлайнОборудованияWebСервис.ПолучитьНастройки(DeviceID);
	Возврат Настройки;
	
КонецФункции

Функция GetPriceList(DeviceID)
	
	ПрайсЛист = МенеджерОфлайнОборудованияWebСервис.ПолучитьПрайсЛист(DeviceID);
	Возврат ПрайсЛист;
	
КонецФункции

Функция GetDocTypes()
	
	Возврат ""; //не используется
	
КонецФункции

Функция PostDocs(DeviceID, DocType, Document)
	
	Ответ = МенеджерОфлайнОборудованияWebСервис.ЗагрузитьДокумент(DeviceID, DocType, Document);
	Возврат Ответ;
	
КонецФункции

Функция PreparePriceList(DeviceID)
	
	ИдентификаторПередачи = МенеджерОфлайнОборудованияWebСервис.ПолучитьИдентификаторПередачиПрайсЛиста(DeviceID);
	Возврат ИдентификаторПередачи;
	
КонецФункции

Функция GetPriceListPackage(DeviceID, TransferID, Restart)
	
	ТекстСообщения = МенеджерОфлайнОборудованияWebСервис.ПолучитьПакетПрайсЛиста(DeviceID, TransferID, Restart);
	Возврат ТекстСообщения;
	
КонецФункции

Функция GetVersion(DeviceID)
	
	Версия = МенеджерОфлайнОборудованияWebСервис.ПолучитьВерсиюФорматаОбмена(DeviceID);
	
	Возврат Версия;
	
КонецФункции

Функция GetGood(DeviceID, BarCode)
	
	Ответ = МенеджерОфлайнОборудованияWebСервис.ПолучитьТовар(DeviceID, BarCode);
	Возврат Ответ;
	
КонецФункции

Функция GetDocs(DeviceID, DocType)
	
	ВыгружаемыеДокументы = МенеджерОфлайнОборудованияWebСервис.ПолучитьДокументы(DeviceID, DocType);
	
	Возврат ВыгружаемыеДокументы;
	
КонецФункции

#КонецОбласти