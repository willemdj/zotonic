%% @doc Tests for mod_acl_user_groups
-module(mod_acl_user_groups_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

person_can_edit_own_resource_test() ->
    Context = z_context:new(testsandboxdb),
    z_module_manager:activate_wait(mod_content_groups, Context),
    z_module_manager:activate_wait(mod_acl_user_groups, Context),

    %% Person must be able to edit person category
    m_acl_rule:replace_managed(
        [
            {rsc, [
                {acl_user_group_id, acl_user_group_members},
                {actions, [view, update]},
                {is_owner, true},
                {category_id, person}
            ]}
        ],
        testsandboxdb,
        z_acl:sudo(Context)
    ),
    m_acl_rule:publish(rsc, z_acl:sudo(Context)),

    {ok, Id} = m_rsc:insert([{category, person}], z_acl:sudo(Context)),

    UserContext = z_acl:logon(Id, Context),
    {ok, Id} = m_rsc:update(Id, [{title, "Test"}], UserContext).
