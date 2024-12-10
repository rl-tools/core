#include "../../../version.h"
#if (defined(RL_TOOLS_DISABLE_INCLUDE_GUARDS) || !defined(RL_TOOLS_RL_ENVIRONMENTS_FLAG_ENVIRONMENT_H)) && (RL_TOOLS_USE_THIS_VERSION == 1)
#pragma once
#define RL_TOOLS_RL_ENVIRONMENTS_FLAG_ENVIRONMENT_H

#include "../../../math/operations_generic.h"
#include "../environments.h"

RL_TOOLS_NAMESPACE_WRAPPER_START
namespace rl_tools::rl::environments::flag{
    template <typename T>
    struct DefaultParameters {
        constexpr static T g = 10;
        constexpr static T max_speed = 8;
        constexpr static T max_torque = 2;
        constexpr static T dt = 0.05;
        constexpr static T m = 1;
        constexpr static T l = 1;
        constexpr static T initial_state_min_angle = -math::PI<T>;
        constexpr static T initial_state_max_angle = math::PI<T>;
        constexpr static T initial_state_min_speed = -1;
        constexpr static T initial_state_max_speed = 1;
    };
    template <typename T_T, typename T_TI, typename T_PARAMETERS = DefaultParameters<T_T>>
    struct Specification{
        using T = T_T;
        using TI = T_TI;
        using PARAMETERS = T_PARAMETERS;
    };

    template <typename TI>
    struct ObservationFourier{
        static constexpr TI DIM = 3;
    };
    template <typename TI>
    struct ObservationRaw{
        static constexpr TI DIM = 2;
    };

    template <typename T, typename TI>
    struct State{
        static constexpr TI DIM = 2;
        T theta;
        T theta_dot;
    };

}
RL_TOOLS_NAMESPACE_WRAPPER_END

RL_TOOLS_NAMESPACE_WRAPPER_START
namespace rl_tools::rl::environments{
    template <typename T_SPEC>
    struct Flag: Environment<typename T_SPEC::T, typename T_SPEC::TI>{
        using SPEC = T_SPEC;
        using T = typename SPEC::T;
        using TI = typename SPEC::TI;
        using State = flag::State<T, TI>;
        using Parameters = typename SPEC::PARAMETERS;
        using Observation = flag::ObservationFourier<TI>;
        using ObservationPrivileged = Observation;
        static constexpr TI N_AGENTS = 1; // single agent
        static constexpr TI ACTION_DIM = 1;
        static constexpr TI EPISODE_STEP_LIMIT = 200;
    };
}
RL_TOOLS_NAMESPACE_WRAPPER_END







#endif
