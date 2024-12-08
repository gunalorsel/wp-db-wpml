create
    definer = root@localhost procedure base_MoveSinglePost()
BEGIN

    DECLARE old INT;
    DECLARE new INT;

    REPEAT

        SET new = base_NextAvailablePostID();
        SET old = base_PostIDToBeMoved();
    
        UPDATE base_posts
            SET ID = new,
                guid = CONCAT('https://cuoresportivo.com/?page=', new)
                WHERE ID = old;
    
        UPDATE base_postmeta
            SET post_id = new WHERE post_id = old;
    
        UPDATE base_term_relationships
            SET object_id = new WHERE object_id = old;
    
        UPDATE base_icl_translations
            SET element_id = new WHERE element_id = old;

        UPDATE base_icl_translations
            SET element_id = new WHERE element_type = 'package_gutenberg' AND element_id = (SELECT ID FROM base_icl_string_packages WHERE post_id = old);

        UPDATE base_icl_string_packages
            SET ID = new, post_id = new, name = new, title = CONCAT('Page Builder Page ', new)  WHERE post_id = old;
    
        UPDATE base_icl_strings
            SET context = CONCAT('gutenberg-',new)
                WHERE string_package_id = new;
    
        UNTIL base_PostIDToBeMoved() IS NULL

    END REPEAT;

END;

