import { useEffect, useState } from 'react'
import { useQuery } from '@apollo/client'
import { gql } from '../../../src/__generated__/gql'
import { Route } from '../../__generated__/gql/graphql'

export const useGetRoutes = () => {
  const [routes, setRoutes] = useState<Route[]>([])

  // fetch viewer count
  const useGetRoutes = gql(`
    query GetRoutes {
      routes{
        name
        url
        ready
      }
    }
  `)

  const { data, loading, error } = useQuery(useGetRoutes, {
    pollInterval: 60 * 1000,
  })

  useEffect(() => {
    if (loading) {
      return
    }
    if (error) {
      // TODO error handling
      console.error(error)
      return
    }
    if (data) {
      const r = data.routes as Route[]
      if (r != null) {
        setRoutes(r)
      }
    }
  }, [data, loading, error])

  return routes
}
