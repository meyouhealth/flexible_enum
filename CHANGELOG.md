Current release (in development)
--------------------------------

0.4.2
-----

*   Enum setter methods raise exceptions in accordance with Rails conventions for bang (`!`) methods. #27

    *Adam Prescott*

0.4.1
-----

*   Add support for Rails 5. #33

    *Alex Robbin*

*   Add inverse scopes. #32

    *Zach Fletcher*

0.4.0
-----

*   Revert #4. Scopes provided by flexible_enum no longer attempt to overwrite pre-existing `WHERE` conditions on the enum column. #30

    *Alex Robbin*

0.3.0
-----

*   Adds `[option_name]_details` method to retrieve custom attributes of the
    current enum option. #24

    *Alex Robbin*
