/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */


#define JUD_LAYOUT_NAMESPACE jud_

#ifdef JUD_LAYOUT_NAMESPACE
    // prefix all layout symbols with "jud_" to prevent conflict
    #define JUD_NAMESPACE_PREFIX_INNER(namespace, symbol) namespace ## symbol
    #define JUD_NAMESPACE_PREFIX(namespace, symbol) JUD_NAMESPACE_PREFIX_INNER(namespace, symbol)
    #define JUD_LAYOUT_PREFIX(symbol) JUD_NAMESPACE_PREFIX(JUD_LAYOUT_NAMESPACE, symbol)

    #define css_direction_t                JUD_LAYOUT_PREFIX(css_direction_t)
    #define css_flex_direction_t           JUD_LAYOUT_PREFIX(css_flex_direction_t)
    #define css_justify_t                  JUD_LAYOUT_PREFIX(css_justify_t)
    #define css_align_t                    JUD_LAYOUT_PREFIX(css_align_t)
    #define css_position_type_t            JUD_LAYOUT_PREFIX(css_position_type_t)
    #define css_wrap_type_t                JUD_LAYOUT_PREFIX(css_wrap_type_t)
    #define css_position_t                 JUD_LAYOUT_PREFIX(css_position_t)
    #define css_dimension_t                JUD_LAYOUT_PREFIX(css_dimension_t)
    #define css_layout_t                   JUD_LAYOUT_PREFIX(css_layout_t)
    #define css_dim_t                      JUD_LAYOUT_PREFIX(css_dim_t)
    #define css_style_t                    JUD_LAYOUT_PREFIX(css_style_t)
    #define css_node                       JUD_LAYOUT_PREFIX(css_node)
    #define css_node_t                     JUD_LAYOUT_PREFIX(css_node_t)
    #define new_css_node                   JUD_LAYOUT_PREFIX(new_css_node)
    #define init_css_node                  JUD_LAYOUT_PREFIX(init_css_node)
    #define free_css_node                  JUD_LAYOUT_PREFIX(free_css_node)
    #define css_print_options_t            JUD_LAYOUT_PREFIX(css_print_options_t)
    #define print_css_node                 JUD_LAYOUT_PREFIX(print_css_node)
    #define layoutNode                     JUD_LAYOUT_PREFIX(layoutNode)
    #define isUndefined                    JUD_LAYOUT_PREFIX(isUndefined)
    #define resetNodeLayout                JUD_LAYOUT_PREFIX(resetNodeLayout)

#endif


#import "Layout.h"



