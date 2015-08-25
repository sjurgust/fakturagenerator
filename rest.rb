
#string = '{"desc":{"someKey":"someValue","anotherKey":"value"},"main_item":{"stats":{"a":8,"b":12,"c":10}}}'
fileObj = '{
    "Filename":"everlive.png",
    "ContentType":"image/png",
    "base64": "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALoSURBVEhLnVbNalNREA7JbZ+gfYQ+QvsI9hVcadOV2HUL2enSuHbVjetm3Z2ga8GFSVoo1AYEoQQqgiIUCvrNz5kz5yf3RsPhcu/NPfPN982cmenNDgbTp4PZQYMr39hq9H6Im/alFvizwfxwQwzOeGPPNjNAPzxmSALWzIcbsk2vAVgt8uP8cJPs0Ge0BQCMRgz6RiXwMMfVo7mxSWk56gAAA3NUAcjfz0/6WE4iAY5XdX8IHp6E48rvo0RM1ElEwRBk2pPGQ1maOIRRasWymETsx8AkMosiSxlttmhGV0deAUJ4lIFLocK60/365d7i9T4WbtJQi0NpFjFGlYF3n7Ytxvs/Pk7+pL+HX9/vPpxeHe+4UFkMJJYRwItuDOhv7P958S4znT1+e/vMZ12UKJwDy5Pc8esXu3Cz3br8+/XNY3O5BEhy0cK7vnUA3C9v7MDGg+YYiERy0GhBmTV9N36Ik+RYmUVqlA+BylXVHS8peYbN1cnO78WnTLrbs5GWEykVLk3pBPhKdzN+VOoO66YyNsNcF4DLIlEm6NOUGQlbSBU6AWNasF4KSAyqEpnuwuvi+dY6aVN+Qwci1iKpplwqpmnZWdT06YSEgLAjZzsPsqkvVEpxO60j4JdH265UbE5RlUOB6Zn0/wdw9/708mjLt7y84VgKSbcpGdwvv+Dl7WREV1uTEaLNjmfntCoRh2EVAwCwj6ElWNGOjdq1ptUxIEeAUT0EqATL81cZA88G91pWDSBmUTFM/GuRkCzALsFIswhpGgBaVOpMJPmAq0UlBtro/WRQlpp1MBxA7OHS0bIu3yA9qgWjBQYSUVIlQSazKlFtrGvQEpbn486O5nonWXTngFtmMN0yrfgBiSZMX1bpPk3cFIAZ8LyVtOL65KLTYAGQTK7CgFGl6RdZVM5FwWL01HudTL5JFsngxdW0b9e2sS4OW27Qw3Y75CxXHgPrxq4x2H6bM6zghHHYs/EAfrpmh/4C3uTevq5C1CEAAAAASUVORK5CYII="
}'

require 'rest_client'

site = RestClient::Resource.new('http://api.everlive.com')
site['/v1/obb5o9V6TFoFQXLM/Files'].post 'hey', :headers => '{ "Authorization" : "Bearer obb5o9V6TFoFQXLM" }',
 	:content_type => "application/json",  
 	:data => fileObj
