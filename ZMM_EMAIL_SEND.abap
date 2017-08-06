REPORT zmm_email_sent_01.

DATA: lt_recepeints TYPE TABLE OF somlreci1,
      ls_recepeints TYPE somlreci1,
      ls_docdata    TYPE sodocchgi1,
      lt_bodydata   TYPE TABLE OF solisti1,
      ls_bodydata   TYPE solisti1.

SELECT * FROM usr02 INTO TABLE @DATA(lt_users).

LOOP AT lt_users INTO DATA(ls_users).
  ls_bodydata-line = ls_users-bname.
  APPEND ls_bodydata TO lt_bodydata.
ENDLOOP.

ls_docdata-obj_name   = 'Email'.
*ls_docdata-obj_descr  = 'Email from' && sy-sysid.
*ls_docdata-sensitivty = 'O'.
*ls_docdata-obj_langu  = sy-langu.

ls_recepeints-receiver = 'x.x@domain.com'.
ls_recepeints-rec_type = 'U'.
ls_recepeints-express = 'X'.
APPEND ls_recepeints TO lt_recepeints.

CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
  EXPORTING
    document_data  = ls_docdata
    document_type  = 'RAW'
    put_in_outbox  = 'X'
  TABLES
    object_content = lt_bodydata
    receivers      = lt_recepeints.
COMMIT WORK.
