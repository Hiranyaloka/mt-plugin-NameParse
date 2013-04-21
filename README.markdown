# NameParse 0.90 for Movable Type 4 and 5 #

Parses a person's name (English only). A thin wrapper around the [Lingua::EN::NameParse](http://search.cpan.org/perldoc?Lingua::EN::NameParse) cpan module by Kim Ryan.

## Block tag `NameParseComponents` ##

`mt:NameParseComponents` parses the contained block, then joins the components with a separator.
Case conversion is optional. The default separator is whitespace.

For example, if you have a variable (or a tag) that contains a person's name:

    <mt:Var  name="namestring" value="MR. FREDERICK J. FLINTSTONE">

Or perhaps the name is in the form "Last, First"

    <mt:SetVarBlock  name="namestring" >
        FLINTSTONE,
            MR. FREDERICK J.
    </mt:SetVarBlock>

NameParse will parse either form to give the same results. To extract and output a first and last name:

    <mt:NameParseComponents components="given_name_1,surname_1">
        <$mt:Var name="namestring" strip_linefeeds="1"$>
    </mt:NameParseComponents></p>

outputs "FREDERICK FLINTSTONE".

Format as 'Frederick Flintstone' with the `case` argument (See the "Case Option" section below)

    <mt:NameParseComponents components="given_name_1,surname_1">
        <$mt:Var name="namestring" strip_linefeeds="1"$>
    </mt:NameParseComponents></p>

To put last name first, followed by first name:

    <mt:NameParseComponents components="surname_1,given_name_1" separator=", ">
        <$mt:Var name="namestring" strip_linefeeds="1"$>
    </mt:NameParseComponents>

outputs "Flinstone, Frederick".

To output the title and surname:

    <mt:NameParseComponents components="title_1,surname_1" case="1">
        <$mt:Var name="namestring" strip_linefeeds="1"$>
    </mt:NameParseComponents>

outputs "Mr. Flintstone".

Supported components:
    precursor, title_1, title_2, given_name_1, given_name_2, initials_1, initials_2,
    middle_name, conjunction_1, conjunction_2, surname_1. surname_2, suffix


## Text filter `case_all_reversed` ##

The reversed name  is returned as surname followed by a comma and the rest of the name.

Particularly useful for sorting, there is a text filter specifically for that:

    <$mt:Var name="namestring" filters="case_all_reversed"$>

outputs "Flinstone, Mr. Frederick J."

## Case Option
The `case_all_reversed` method (and `case` option) converts the first letter of each component to capitals
and the remainder to lower case, with the following exceptions-
   
    initials remain capitalised
    surname spelling such as MacNay-Smith, O'Brien and Van Der Heiden are preserved
        - see C<surname_prefs.txt> for user defined exceptions
   

## Example Usage: Create an image gallery sorted by last name ##

Suppose you have image assets where the Asset Label is a person's name. When used with the `NameParse` plugin, an image gallery can be produced in rows of 3 (or 4 etc), and sorted by the last name, parsed from the AssetLabel.

A [recent branch of mt-plugin-Order](https://github.com/Hiranyaloka/mt-plugin-Order/tree/items_per_row) (called `items_per_row`) allows for setting `items_per_row` in the `mt:Order` tag. The `items_per_row` attributethen enables `mt:OrderRowHeader` and `mt:OrderRowFooter` tags.

    <mt:Order sort_order="ascend" items_per_row="3">
        <mt:OrderRowHeader><div class="gallery"></mt:OrderRowHeader>
        <mt:OrderRowFooter></div></mt:OrderRowFooter>
        <mt:Assets type="image" tag="gallery">
            <mt:OrderItem>
                <mt:setvarblock name="order_by">
                    <$mt:AssetLabel convert_breaks="0" filters="case_all_reversed"$>
                </mt:setvarblock>
                <dl>
                    <dt><img src="<$mt:AssetThumbnailURL width="144"$>" /></dt>
    	              <dt>
    	                  <mt:NameParseComponents components="given_name_1,surname_1">
    	                      <$mt:AssetLabel$>
    	                  </mt:NameParseComponents>
    	              </dt>
                    <dd><$mt:AssetDescription convert_breaks="0" filters="__default__"$></dd>
                </dl>
            </mt:OrderItem>
        </mt:Assets>
    </mt:Order>

## Dependencies ##

Bundled with [Lingua::EN::NameCase](http://search.cpan.org/perldoc?Lingua::EN::NameParse)

## ChangeLog ##

- version 0.9 Added `case` option.  Added `components` argument, which replaces the individual component arguments used in prior versions.

## Credits ##

Kim Ryan, author of [Lingua::EN::NameCase](http://search.cpan.org/perldoc?Lingua::EN::NameParse)

Damian Conway,  author of [Parse::RecDescent](http://search.cpan.org/perldoc?Parse::RecDescent)
