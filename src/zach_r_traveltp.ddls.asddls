@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Travel'
@VDM.viewType: #TRANSACTIONAL
@Search.searchable: true

define root view entity ZACH_R_TRAVELTP
  as select from ZACH_R_TRAVEL
  composition [1..*] of ZACH_R_BOOKINGTP  as _Booking
  association [0..1] to ZACH_R_CUSTOMERTP as _Customer      on $projection.Customerid = _Customer.Customerid

  //Extensions
  association [1]    to ZACH_E_R_TRAVEL      as _Extensions on $projection.Traveluuid = _Extensions.TrevelUUID
{
      @Search.defaultSearchElement: true
  key Traveluuid,
      Travelid,
      @Search.defaultSearchElement: true
      Customerid,
      Begindate,
      Enddate,
      Bookingfee,
      Totalprice,
      Currencycode,
      @Search.defaultSearchElement: true
      Overallstatus,
      Description,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _Booking,
      _Customer,
      _Extensions
}
