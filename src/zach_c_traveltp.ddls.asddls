@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Travel'
@Metadata.allowExtensions: true

@VDM: {
    viewType: #CONSUMPTION,
    usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
}

@Search.searchable: true

define root view entity ZACH_C_TRAVELTP
  provider contract transactional_query
  as projection on ZACH_R_TRAVELTP as Travel
{
  key     Traveluuid,
          @Search.defaultSearchElement: true
          Travelid,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZACH_C_CUSTOMERVH', element: 'Customerid' } }]
          Customerid,
          @EndUserText.label: 'Begin Date'
          //@Consumption.filter.hidden: true
          Begindate,
          Enddate,
          Bookingfee,
          Totalprice,
          Currencycode,
          Overallstatus,
          Description,
          Createdby,
          Createdat,
          Lastchangedby,
          Lastchangedat,
          Locallastchangedat,
          /* Associations */
          _Booking : redirected to composition child ZACH_C_BOOKINGTP,
          //    _Customer

          @EndUserText.label: 'Is My Travel'
          @EndUserText.quickInfo: 'Is My Travel'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZACH_TRAVEL_VIRTUALFIELD'
  virtual IsMyTravel   : abap.char( 1 ),
          @EndUserText.label: 'Days To Flueght'
          @ObjectModel.filter.transformedBy: 'ABAP:ZACH_TRAVEL_VIRTUALFIELD'
          @ObjectModel.sort.transformedBy: 'ABAP:ZACH_TRAVEL_VIRTUALFIELD'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZACH_TRAVEL_VIRTUALFIELD'
  virtual DaysToFlight : abap.int4
}
