//
//  maaku.c
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#include "maaku.h"

cmark_llist *maaku_filter_get_extensions(void) {
    cmark_syntax_extension *tagfilter = cmark_find_syntax_extension("tagfilter");
    
    if (tagfilter) {
        return cmark_llist_append(cmark_get_default_mem_allocator(), NULL, tagfilter);
    }
    
    return NULL;
}
